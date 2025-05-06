<?php

namespace App\Http\Controllers\Api\Auth;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Password;
use Illuminate\Support\Facades\Validator;
use Illuminate\Support\Facades\Log;

class ForgotPasswordController extends Controller
{
    public function sendResetLink(Request $request)
    {
        // Validation similaire à celle dans le code Flutter
        $validator = Validator::make($request->all(), [
            'email' => 'required|email|exists:users,email',
        ], [
            'email.required' => 'Veuillez entrer votre email',
            'email.email' => 'Format d\'email invalide',
            'email.exists' => 'Cet email n\'existe pas dans notre système'
        ]);

        if ($validator->fails()) {
            return response()->json([
                'status' => false,
                'message' => 'Validation échouée',
                'errors' => $validator->errors()
            ], 422);
        }

        try {
            $status = Password::sendResetLink(
                $request->only('email')
            );

            if ($status === Password::RESET_LINK_SENT) {
                return response()->json([
                    'status' => true,
                    'message' => 'Un e-mail de réinitialisation a été envoyé à '.$request->email
                ]);
            }

            return response()->json([
                'status' => false,
                'message' => 'Impossible d\'envoyer l\'e-mail'
            ], 500);

        } catch (\Exception $e) {
            Log::error('Password reset error: '.$e->getMessage());
            
            return response()->json([
                'status' => false,
                'message' => 'Impossible d\'envoyer l\'e-mail : '.$e->getMessage()
            ], 500);
        }
    }
}