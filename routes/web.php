<?php

use Illuminate\Support\Facades\Route;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Password;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\DB;




/*
|--------------------------------------------------------------------------
| Web Routes
|--------------------------------------------------------------------------
|
| Here is where you can register web routes for your application. These
| routes are loaded by the RouteServiceProvider and all of them will
| be assigned to the "web" middleware group. Make something great!
|
*/

Route::get('/', function () {
    return view('welcome');
});

Route::middleware('web')->group(function () {
    Route::get('/reset-password/{token}', function ($token) {
        return view('auth.reset-password', ['token' => $token]);
    })->name('password.reset');

});




// Affiche le formulaire
Route::get('/reset-password/{token}', function ($token, Request $request) {
    $email = $request->query('email');

    // Vérifie si le token est valide
    $record = DB::table('password_reset_tokens')
              ->where('email', $email)
              ->first();

    if (!$record || !Hash::check($token, $record->token)) {
        abort(404, 'Lien invalide ou expiré');
    }

    return view('auth.reset-password', [
        'token' => $token,
        'email' => $email
    ]);
})->name('password.reset');

// Traite la soumission
Route::post('/reset-password', function (Request $request) {
    $request->validate([
        'token' => 'required',
        'email' => 'required|email',
        'password' => 'required|confirmed|min:8',
    ]);

    $status = Password::reset(
        $request->only('email', 'password', 'password_confirmation', 'token'),
        function ($user, $password) {
            $user->forceFill([
                'password' => Hash::make($password)
            ])->save();
        }
    );

    return $status === Password::PASSWORD_RESET
        ? redirect('/')->with('status', 'Mot de passe modifié!')
        : back()->withErrors(['email' => [__($status)]]);
})->name('password.update');
