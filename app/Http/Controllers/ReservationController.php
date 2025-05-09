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

/**
 * Récupère toutes les réservations
 */
public function index()
{
    try {
        // Récupère toutes les réservations avec les infos utilisateur
        $reservations = Reservation::with(['user' => function($query) {
                            $query->select('id', 'nom', 'prenom');
                        }])
                        ->orderBy('date', 'desc')
                        ->orderBy('time', 'desc')
                        ->get();

        // Formatage de la réponse
        $response = [
            'status' => 'success',
            'message' => $reservations->isEmpty()
                ? 'Aucune réservation trouvée.'
                : 'Liste des réservations récupérée avec succès.',
            'count' => $reservations->count(),
            'data' => $reservations->map(function ($reservation) {
                return [
                    'id' => $reservation->id,
                    'date' => $reservation->date,
                    'heure' => $reservation->time,
                    'nombre_personnes' => $reservation->num_of_people,
                    'client' => $reservation->user
                        ? $reservation->user->nom . ' ' . $reservation->user->prenom
                        : 'Client non renseigné',
                    'telephone' => $reservation->phone,
                    'created_at' => $reservation->created_at->format('d/m/Y H:i')
                ];
            })
        ];

        return response()->json($response);

    } catch (\Exception $e) {
        Log::error('Erreur ReservationController@index: ' . $e->getMessage());

        return response()->json([
            'status' => 'error',
            'message' => 'Erreur lors de la récupération des réservations.',
            'error' => env('APP_DEBUG') ? $e->getMessage() : null
        ], 500);
    }
}

/**
 * Récupère une réservation spécifique
 */
public function show($id)
{
    try {
        $reservation = Reservation::with('user')->find($id);

        if (!$reservation) {
            return response()->json([
                'status' => 'error',
                'message' => 'Réservation non trouvée.'
            ], 404);
        }

        return response()->json([
            'status' => 'success',
            'message' => 'Réservation trouvée.',
            'data' => $reservation
        ]);

    } catch (\Exception $e) {
        Log::error('Erreur lors de la récupération de la réservation : ' . $e->getMessage());

        return response()->json([
            'status' => 'error',
            'message' => 'Une erreur est survenue lors de la récupération de la réservation.'
        ], 500);
    }
}

/**
 * Met à jour une réservation
 */
public function update(Request $request, $id)
{
    try {
        $reservation = Reservation::find($id);

        if (!$reservation) {
            return response()->json([
                'status' => 'error',
                'message' => 'Réservation non trouvée.'
            ], 404);
        }

        // Validation
        $validator = Validator::make($request->all(), [
            'nom' => 'sometimes|string|max:255',
            'prenom' => 'sometimes|string|max:255',
            'phone' => 'sometimes|string|max:20',
            'date' => 'sometimes|date',
            'time' => 'sometimes|string|max:10',
            'num_of_people' => 'sometimes|integer|min:1'
        ]);

        if ($validator->fails()) {
            return response()->json([
                'status' => 'error',
                'message' => 'Validation échouée.',
                'errors' => $validator->errors()
            ], 422);
        }

        $reservation->update($request->all());

        return response()->json([
            'status' => 'success',
            'message' => 'Réservation mise à jour avec succès.',
            'data' => $reservation
        ]);

    } catch (\Exception $e) {
        Log::error('Erreur lors de la mise à jour de la réservation : ' . $e->getMessage());

        return response()->json([
            'status' => 'error',
            'message' => 'Une erreur est survenue lors de la mise à jour de la réservation.'
        ], 500);
    }
}

/**
 * Supprime une réservation
 */
public function destroy($id)
{
    try {
        $reservation = Reservation::find($id);

        if (!$reservation) {
            return response()->json([
                'status' => 'error',
                'message' => 'Réservation non trouvée.'
            ], 404);
        }

        $reservation->delete();

        return response()->json([
            'status' => 'success',
            'message' => 'Réservation supprimée avec succès.'
        ]);

    } catch (\Exception $e) {
        Log::error('Erreur lors de la suppression de la réservation : ' . $e->getMessage());

        return response()->json([
            'status' => 'error',
            'message' => 'Une erreur est survenue lors de la suppression de la réservation.'
        ], 500);
    }
}
}