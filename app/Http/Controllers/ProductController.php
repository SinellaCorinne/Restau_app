<?php

namespace App\Http\Controllers;

use App\Models\Product;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

class ProductController extends Controller
{
    // Récupérer tous les produits
    public function index()
    {
        $products = Product::all();

        if ($products->isEmpty()) {
            return response()->json([
                'status' => 'success',
                'message' => 'Aucun produit disponible pour le moment.',
                'data' => []
            ]);
        }

        return response()->json([
            'status' => 'success',
            'message' => 'Produits récupérés avec succès.',
            'data' => $products
        ]);
    }

    // Créer un nouveau produit
    public function store(Request $request)
    {
        $validated = $request->validate([
            'name' => 'required|string|max:255',
            'description' => 'required|string',
            'price' => 'required|numeric|min:0',
            'image_url' => 'nullable|url'
        ]);

        // Réinitialiser l'auto-incrément si la table est vide
        if (Product::count() === 0) {
            DB::statement('ALTER TABLE products AUTO_INCREMENT = 1');
        }

        $product = Product::create($validated);

        return response()->json([
            'status' => 'success',
            'message' => 'Produit ajouté avec succès.',
            'data' => $product
        ], 201);
    }

    // Récupérer un produit spécifique
    public function show($id)
    {
        $product = Product::find($id);

        if (!$product) {
            return response()->json([
                'status' => 'error',
                'message' => 'Produit non trouvé.'
            ], 404);
        }

        return response()->json([
            'status' => 'success',
            'message' => 'Produit récupéré avec succès.',
            'data' => $product
        ]);
    }

    // Mettre à jour un produit
    public function update(Request $request, $id)
    {
        $product = Product::find($id);

        if (!$product) {
            return response()->json([
                'status' => 'error',
                'message' => 'Produit non trouvé.'
            ], 404);
        }

        $validated = $request->validate([
            'name' => 'sometimes|string|max:255',
            'description' => 'sometimes|string',
            'price' => 'sometimes|numeric|min:0',
            'image_url' => 'nullable|url'
        ]);

        $product->update($validated);

        return response()->json([
            'status' => 'success',
            'message' => 'Produit mis à jour avec succès.',
            'data' => $product
        ]);
    }

    // Supprimer un produit
    public function destroy($id)
    {
        $product = Product::find($id);

        if (!$product) {
            return response()->json([
                'status' => 'error',
                'message' => 'Produit non trouvé.'
            ], 404);
        }

        $product->delete();

        return response()->json([
            'status' => 'success',
            'message' => 'Produit supprimé avec succès.'
        ]);
    }

    // Réinitialiser les IDs (optionnel)
    public function resetIds()
    {
        // Seulement pour le développement - pas recommandé en production
        if (app()->environment('local')) {
            DB::statement('ALTER TABLE products AUTO_INCREMENT = 1');
            return response()->json([
                'status' => 'success',
                'message' => 'ID sequence réinitialisée.'
            ]);
        }

        return response()->json([
            'status' => 'error',
            'message' => 'Non autorisé en production.'
        ], 403);
    }
}