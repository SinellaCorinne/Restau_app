<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;
use App\Models\Reservation;
use Illuminate\Support\Facades\Log;

class ReservationController extends Controller
{
    public function __construct()
    {
        // Middleware d'authentification par Sanctum
        $this->middleware('auth:sanctum');
    }

    public function store(Request $request)
    {
        $user = $request->user();

        if (!$user) {
            return response()->json([
                'status' => 'error',
                'message' => 'Utilisateur non authentifié.'
            ], 401);
        }

        // Validation des données
        $validator = Validator::make($request->all(), [
            'nom' => 'required|string|max:255',
            'prenom' => 'required|string|max:255',
            'phone' => 'required|string|max:20',
            'date' => 'required|date',
            'time' => 'required|string|max:10',
            'num_of_people' => 'required|integer|min:1'
        ]);

        if ($validator->fails()) {
            return response()->json([
                'status' => 'error',
                'message' => 'Validation échouée.',
                'errors' => $validator->errors()
            ], 422);
        }

        try {
            $reservation = new Reservation();
            $reservation->nom = $request->nom;
            $reservation->prenom = $request->prenom;
            $reservation->phone = $request->phone;
            $reservation->date = $request->date;
            $reservation->time = $request->time;
            $reservation->num_of_people = $request->num_of_people;
            $reservation->user_id = $user->id;

            $reservation->save();

            return response()->json([
                'status' => 'success',
                'message' => 'Réservation ajoutée avec succès.',
                'reservation' => $reservation
            ], 201);

        } catch (\Exception $e) {
            Log::error('Erreur lors de l’enregistrement de la réservation : ' . $e->getMessage());

            return response()->json([
                'status' => 'error',
                'message' => 'Une erreur est survenue lors de l’enregistrement.',
            ], 500);
        }
    }
}
