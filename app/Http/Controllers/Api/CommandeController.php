<?php

namespace App\Http\Controllers\API;

use App\Http\Controllers\Controller;
use App\Models\Commande;
use App\Models\Product; // Changé de Produit à Product
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Log;
use Illuminate\Support\Facades\Validator;

class CommandeController extends Controller
{
    /**
     * Crée une nouvelle commande
     */
    public function store(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'adresse' => 'required|string|max:255',
            'remarque' => 'nullable|string|max:500',
            'heure' => 'nullable|date|after_or_equal:now', // Changé à nullable
            'methode_paiement' => 'required|in:Espèce,Mobile Money,Carte bancaire',
            'details_paiement' => 'required|array',
            'panier' => 'required|array|min:1',
            'panier.*.produit_id' => 'required|integer|exists:products,id',
            'panier.*.quantite' => 'required|integer|min:1|max:20',
            'panier.*.prix_unitaire' => 'required|numeric|min:0',
        ], [
            'heure.after_or_equal' => 'La date de livraison doit être future',
            'panier.*.produit_id.exists' => 'Un produit sélectionné n\'existe pas'
        ]);

        if ($validator->fails()) {
            return response()->json([
                'status' => 'error',
                'message' => 'Validation échouée',
                'errors' => $validator->errors()
            ], 422);
        }

        try {
            // Vérifier la disponibilité des produits
            foreach ($request->panier as $item) {
                $product = Product::find($item['produit_id']); // Changé vers Product
                if (!$product || $product->stock < $item['quantite']) {
                    return response()->json([
                        'status' => 'error',
                        'message' => 'Produit non disponible: ' . ($product->name ?? 'ID '.$item['produit_id'])
                    ], 400);
                }
            }

            // Créer la commande
            $commande = Commande::create([
                'user_id' => Auth::id(),
                'adresse' => $request->adresse,
                'remarque' => $request->remarque,
                'heure' => $request->heure ?? now()->addHours(2), // Valeur par défaut: maintenant + 2h
                'methode_paiement' => $request->methode_paiement,
                'details_paiement' => $request->details_paiement,
                'panier' => $this->formatPanierItems($request->panier),
                'montant_total' => $this->calculateTotal($request->panier)
            ]);

            // Mettre à jour les stocks
            foreach ($request->panier as $item) {
                Product::where('id', $item['produit_id']) // Changé vers Product
                       ->decrement('stock', $item['quantite']);
            }

            return response()->json([
                'status' => 'success',
                'message' => 'Commande créée avec succès',
                'data' => $this->formatCommandeResponse($commande)
            ], 201);

        } catch (\Exception $e) {
            Log::error('Erreur CommandeController@store: '.$e->getMessage());
            return response()->json([
                'status' => 'error',
                'message' => 'Erreur lors de la création de la commande'
            ], 500);
        }
    }

    /**
     * Liste toutes les commandes
     */
    public function index()
    {
        try {
            $commandes = Commande::with(['user:id,nom,prenom'])
                              ->orderBy('created_at', 'desc')
                              ->get();

            return response()->json([
                'status' => 'success',
                'data' => [
                    'commandes' => $commandes->map(function ($commande) {
                        return $this->formatCommandeResponse($commande, true);
                    }),
                    'meta' => [
                        'total_commandes' => $commandes->count(),
                        'montant_total' => $commandes->sum('montant_total')
                    ]
                ]
            ]);

        } catch (\Exception $e) {
            Log::error('Erreur CommandeController@index: '.$e->getMessage());
            return response()->json([
                'status' => 'error',
                'message' => 'Erreur lors de la récupération des commandes'
            ], 500);
        }
    }

    /**
     * Affiche une commande spécifique
     */
    public function show($id)
    {
        try {
            $commande = Commande::with(['user:id,nom,prenom,telephone'])
                              ->find($id);

            if (!$commande) {
                return response()->json([
                    'status' => 'error',
                    'message' => 'Commande non trouvée'
                ], 404);
            }

            return response()->json([
                'status' => 'success',
                'data' => $this->formatCommandeResponse($commande)
            ]);

        } catch (\Exception $e) {
            Log::error('Erreur CommandeController@show: '.$e->getMessage());
            return response()->json([
                'status' => 'error',
                'message' => 'Erreur lors de la récupération de la commande'
            ], 500);
        }
    }

    /*****************************************************************
     * METHODES PRIVEES
     *****************************************************************/

    /**
     * Calcule le montant total du panier
     */
    private function calculateTotal(array $panier): float
    {
        return collect($panier)->sum(fn($item) =>
            ($item['prix_unitaire'] ?? 0) * ($item['quantite'] ?? 1)
        );
    }

    /**
     * Formate les articles du panier
     */
    private function formatPanierItems(array $panier): array
    {
        return array_map(function ($item) {
            $product = Product::find($item['produit_id']); // Changé vers Product

            return [
                'produit_id' => $item['produit_id'],
                'nom' => $product->name ?? 'Produit inconnu', // Utilisation de name
                'quantite' => $item['quantite'],
                'prix_unitaire' => $item['prix_unitaire'] ?? $product->price,
                'sous_total' => ($item['prix_unitaire'] ?? $product->price) * $item['quantite'],
                'image' => $product->image_url
            ];
        }, $panier);
    }

    /**
     * Formate la réponse de la commande
     */
    private function formatCommandeResponse(Commande $commande, bool $summary = false): array
    {
        $baseResponse = [
            'id' => $commande->id,
            'reference' => 'CMD-'.$commande->id,
            'client' => $commande->user ? $commande->user->nom.' '.$commande->user->prenom : 'Anonyme',
            'montant_total' => $commande->montant_total,
            'statut' => $commande->statut ?? 'confirmée',
            'date' => $commande->created_at->format('d/m/Y H:i')
        ];

        if ($summary) {
            return array_merge($baseResponse, [
                'articles_count' => count($commande->panier)
            ]);
        }

        return array_merge($baseResponse, [
            'infos_livraison' => [
                'adresse' => $commande->adresse,
                'heure' => $commande->heure->format('H:i'),
                'remarque' => $commande->remarque
            ],
            'paiement' => [
                'methode' => $commande->methode_paiement,
                'details' => $commande->details_paiement
            ],
            'contact_client' => [
                'telephone' => $commande->user->telephone ?? null
            ],
            'articles' => collect($commande->panier)->map(function ($item) {
                return [
                    'produit_id' => $item['produit_id'],
                    'nom' => $item['nom'],
                    'quantite' => $item['quantite'],
                    'prix_unitaire' => $item['prix_unitaire'],
                    'sous_total' => $item['sous_total'],
                    'image' => $item['image']
                ];
            })
        ]);
    }
}
