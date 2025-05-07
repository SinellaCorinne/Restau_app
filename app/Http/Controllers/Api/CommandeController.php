<?php

namespace App\Http\Controllers\API;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\Commande;
use Illuminate\Support\Facades\Auth;


class CommandeController extends Controller
{
    public function store(Request $request)
    {
        $request->validate([
            'adresse' => 'required|string',
            'remarque' => 'nullable|string',
            'heure' => 'required|date',
            'methode_paiement' => 'required|string|in:Espèce,Mobile Money,Carte bancaire',
            'details_paiement' => 'required|array',
            'panier' => 'required|array',
        ]);

        $commande = Commande::create([
            'user_id' => Auth::id(),
            'adresse' => $request->adresse,
            'remarque' => $request->remarque,
            'heure' => $request->heure,
            'methode_paiement' => $request->methode_paiement,
            'details_paiement' => $request->details_paiement,
            'panier' => $request->panier,
        ]);

        return response()->json([
            'message' => 'Commande enregistrée avec succès.',
            'commande' => $commande,
        ], 201);
    }
}
