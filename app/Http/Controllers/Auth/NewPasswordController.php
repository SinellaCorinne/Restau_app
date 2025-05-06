<?php

namespace App\Http\Controllers\Auth;

use App\Http\Controllers\Controller;
use Illuminate\Auth\Events\PasswordReset;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Str;
use Illuminate\Validation\Rules;
use Illuminate\Validation\ValidationException;
use Illuminate\Support\Facades\Password;
use App\Models\User;
use Illuminate\Notifications\Notification;

class NewPasswordController extends Controller
{
    /**
     * Handle an incoming new password request (password reset).
     *
     * @throws \Illuminate\Validation\ValidationException
     */
    public function store(Request $request): JsonResponse
    {
        // Validation des données reçues
        $request->validate([
            'token' => ['required'],
            'email' => ['required', 'email'],
            'password' => ['required', 'confirmed', Rules\Password::defaults()],
        ]);

        // Tentative de réinitialisation du mot de passe
        $status = Password::reset(
            $request->only('email', 'password', 'password_confirmation', 'token'),
            function ($user) use ($request) {
                // Mettre à jour le mot de passe de l'utilisateur
                $user->forceFill([
                    'password' => Hash::make($request->password),
                    'remember_token' => Str::random(60), // Générer un token pour "remember me"
                ])->save();

                // Déclencher l'événement de réinitialisation du mot de passe
                event(new PasswordReset($user));
            }
        );

        // Si la réinitialisation est un succès, on renvoie un message de succès
        if ($status != Password::PASSWORD_RESET) {
            // Si l'opération échoue, on lance une exception de validation
            throw ValidationException::withMessages([
                'email' => [__($status)],
            ]);
        }

        return response()->json(['status' => __($status)]);
    }

    /**
     * Reset the password after the user clicks the reset link.
     *
     * @param  \Illuminate\Http\Request  $request
     * @return \Illuminate\Http\JsonResponse
     */
    public function reset(Request $request)
    {
        // Validation des données de réinitialisation du mot de passe
        $request->validate([
            'token' => 'required',
            'email' => 'required|email',
            'password' => ['required', 'confirmed', Rules\Password::defaults()],
        ]);

        // Tentative de réinitialisation du mot de passe
        $status = Password::reset(
            $request->only('email', 'password', 'password_confirmation', 'token'),
            function (User $user, string $password) {
                // Mise à jour du mot de passe de l'utilisateur
                $user->forceFill([
                    'password' => Hash::make($password),
                ])->save();
            }
        );

        // Si la réinitialisation est un succès, renvoyer une réponse de succès
        return $status === Password::PASSWORD_RESET
                ? response()->json(['message' => __($status)])
                : response()->json(['message' => __($status)], 400);
    }

    /**
     * Afficher le formulaire pour réinitialiser le mot de passe.
     *
     * @param  \Illuminate\Http\Request  $request
     * @param  string  $token
     * @return \Illuminate\View\View
     */
    public function showResetForm(Request $request, $token)
    {
        // Ici, vous pouvez renvoyer la vue pour afficher le formulaire de réinitialisation de mot de passe
        return view('auth.passwords.reset')->with(
            ['token' => $token, 'email' => $request->email]
        );
    }
}