<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;


use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Storage;
use App\Models\User;

class UserController extends Controller
{


    public function update(Request $request)
    {
        $user = auth()->user();

        $request->validate([
            'nom' => 'sometimes|string|max:255',
            'prenom' => 'sometimes|string|max:255',
            'email' => 'sometimes|email|unique:users,email,' . $user->id,
            'telephone' => 'sometimes|string|max:20',
            'adresse' => 'nullable|string',
            'ville' => 'nullable|string',
            'preferences' => 'nullable|string',
            'photo' => 'nullable|image|max:2048',
        ]);

        if ($request->hasFile('photo')) {
            // Supprimer l'ancienne photo si elle existe
            if ($user->photo && Storage::exists($user->photo)) {
                Storage::delete($user->photo);
            }

            $path = $request->file('photo')->store('photos');
            $user->photo = $path;
        }

        // Mise à jour des autres champs
        $user->fill($request->only([
            'nom', 'prenom', 'email', 'telephone', 'adresse', 'ville', 'preferences'
        ]));

        $user->save();

        return response()->json([
            'message' => 'Profil mis à jour avec succès',
            'user' => $user,
        ]);
    }

}
