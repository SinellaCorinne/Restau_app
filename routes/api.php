<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\Api\AuthController;
use App\Http\Controllers\Api\Auth\ForgotPasswordController;
use App\Http\Controllers\Auth\PasswordResetLinkController;
use App\Http\Controllers\Auth\NewPasswordController;
use App\Http\Controllers\ReservationController;
use App\Http\Controllers\API\CommandeController;
use App\Http\Controllers\UserController;
use App\Http\Controllers\PasswordController;
use App\Http\Controllers\ProductController;







/*
|--------------------------------------------------------------------------
| API Routes
|--------------------------------------------------------------------------
|
| Here is where you can register API routes for your application. These
| routes are loaded by the RouteServiceProvider and all of them will
| be assigned to the "api" middleware group. Make something great!
|
*/


//Route pour s'authentifier
Route::post('register', [AuthController::class, 'register']);
Route::post('login', [AuthController::class, 'login']);
Route::get('users', [UserController::class, 'getAllUsers']);

Route::middleware('auth:sanctum')->group(function () {
    Route::get('user', [AuthController::class, 'user']);
    Route::post('logout', [AuthController::class, 'logout']);
});

//Route pour mettre à jour son profil
Route::middleware('auth:sanctum')->group(function () {
    Route::get('/user', [UserController::class, 'getUserInfo']);
    Route::put('/user/update', [UserController::class, 'updateUserInfo']);
    Route::post('/user/update-photo', [UserController::class, 'updateProfilePhoto']);

});
Route::put('/update-password', [PasswordController::class, 'update'])
    ->middleware('auth:sanctum');

//Route pour la rénitialisation du mot de passe
Route::post('/forgot-password', [PasswordResetLinkController::class, 'sendResetLinkEmail']);

Route::post('/reset-password', [NewPasswordController::class, 'reset']);

Route::get('/reset-password-preview', function (Request $request) {
    return response()->json([
        'token' => $request->token,
        'email' => $request->email,
        'message' => 'Copiez ce token et utilisez-le pour appeler POST /api/reset-password',
    ]);
});




//Route pour les produits
Route::apiResource('products', ProductController::class);

// Route optionnelle pour réinitialiser les IDs (dev seulement)
Route::post('/products/reset-ids', [ProductController::class, 'resetIds'])
    ->middleware('env:local');



// Routes pour les menus
Route::get('/menu', [ProductController::class, 'fullMenu']);
Route::get('/menu/{categorySlug}', [ProductController::class, 'byMenuCategory']);





//Route pour les reservations
Route::middleware('auth:sanctum')->group(function () {

    Route::post('/reservations', [ReservationController::class, 'store']);

    Route::get('/reservations', [ReservationController::class, 'index']);
    Route::get('/reservations/{id}', [ReservationController::class, 'show']);
    Route::put('/reservations/{id}', [ReservationController::class, 'update']);
    Route::delete('/reservations/{id}', [ReservationController::class, 'destroy']);
    Route::put('/commandes/{id}', [CommandeController::class, 'update']);
    Route::delete('/commandes/{id}', [CommandeController::class, 'destroy']);
});

Route::get('/users/{userId}/reservations', [ReservationController::class, 'userReservations']);


//Route pour les commandes
Route::middleware('auth:sanctum')->group(function () {
    Route::post('/commandes', [CommandeController::class, 'store']);
    Route::get('/commandes', [CommandeController::class, 'index']);
    Route::get('/commandes/{id}', [CommandeController::class, 'show']);
});




//Route pour le panier
