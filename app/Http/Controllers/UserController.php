<?php


namespace App\Http\Controllers;

use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;

class UserController extends Controller
{ // Récupérer les infos de l'utilisateur connecté
    public function getUserInfo()
    {
        $user = Auth::user();
        return response()->json($user);
    }

    // Mettre à jour les infos de l'utilisateur
    public function updateUserInfo(Request $request)
    {
        $user = Auth::user();

        $validatedData = $request->validate([
            'nom' => 'sometimes|string|max:255',
            'prenom' => 'sometimes|string|max:255',
            'telephone' => 'sometimes|string|max:20',
            'email' => 'sometimes|string|email|max:255|unique:users,email,'.$user->id,
            'adresse' => 'nullable|string|max:255',
            'ville' => 'nullable|string|max:255',
            'preferences' => 'nullable|string',
            // 'password' est géré séparément pour le hachage
            // 'photo' est géré via updateProfilePhoto
        ]);

        $user->update($validatedData);

        return response()->json([
            'message' => 'Informations mises à jour avec succès',
            'user' => $user
        ]);
    }
//mettre à jour le mot de passe

public function updatePassword(Request $request)
{
    $user = Auth::user();

    // Vérification CRUCIALE avec password_verify()
    if (!password_verify($request->current_password, $user->password)) {
        return response()->json([
            'success' => false,
            'message' => 'Mot de passe actuel incorrect'
        ], 401);
    }

    // Mise à jour DIRECTE avec bcrypt
    $user->password = bcrypt($request->new_password);
    $user->save();

    return response()->json([
        'success' => true,
        'message' => 'Mot de passe mis à jour avec succès'
    ]);
}


    // Mettre à jour la photo de profil
    public function updateProfilePhoto(Request $request)
    {
        $request->validate([
            'photo' => 'required|image|mimes:jpeg,png,jpg,gif|max:2048',
        ]);

        $user = Auth::user();

        if ($request->hasFile('photo')) {
            $path = $request->file('photo')->store('profile_photos', 'public');
            $user->photo = $path;
            $user->save();
        }

        return response()->json([
            'message' => 'Photo de profil mise à jour avec succès',
            'photo_path' => $user->photo
        ]);
    }
}
