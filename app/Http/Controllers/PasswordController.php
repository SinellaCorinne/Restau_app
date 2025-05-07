<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use App\Models\User;

class PasswordController extends Controller
{
    public function update(Request $request)
    {
        $user = Auth::user();
        
        // Debug: Vérifions ce que nous recevons
        \Log::debug('Password Update Attempt', [
            'user_id' => $user->id,
            'input_current' => $request->current_password,
            'db_password' => $user->password
        ]);

        // Vérification brute avec password_verify
        if (!password_verify($request->current_password, $user->password)) {
            \Log::error('Password Mismatch', [
                'input' => $request->current_password,
                'stored' => $user->password
            ]);
            return response()->json(['error' => 'ACCÈS REFUSÉ: Mot de passe incorrect'], 401);
        }

        // Mise à jour directe en base
        User::where('id', $user->id)->update([
            'password' => password_hash($request->new_password, PASSWORD_BCRYPT)
        ]);

        return response()->json([
            'success' => true,
            'message' => 'Mot de passe actualisé avec succès',
            'changed_at' => now()->toDateTimeString()
        ]);
    }
}