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



Route::post('register', [AuthController::class, 'register']);
Route::post('login', [AuthController::class, 'login']);

Route::middleware('auth:sanctum')->group(function () {
    Route::get('user', [AuthController::class, 'user']);
    Route::post('logout', [AuthController::class, 'logout']);
});



Route::apiResource('products', ProductController::class);

// Route optionnelle pour réinitialiser les IDs (dev seulement)
Route::post('/products/reset-ids', [ProductController::class, 'resetIds'])
    ->middleware('env:local');


Route::post('/forgot-password', [PasswordResetLinkController::class, 'sendResetLinkEmail']);

Route::post('/reset-password', [NewPasswordController::class, 'reset']);

Route::get('/reset-password-preview', function (Request $request) {
    return response()->json([
        'token' => $request->token,
        'email' => $request->email,
        'message' => 'Copiez ce token et utilisez-le pour appeler POST /api/reset-password',
    ]);
});



Route::middleware('auth:sanctum')->post('/reservations', [ReservationController::class, 'store']);

Route::middleware('auth:sanctum')->group(function () {
    Route::post('/commandes', [CommandeController::class, 'store']);
});



Route::middleware('auth:sanctum')->group(function () {
    Route::get('/user', [UserController::class, 'getUserInfo']);
    Route::put('/user/update', [UserController::class, 'updateUserInfo']);
    Route::post('/user/update-photo', [UserController::class, 'updateProfilePhoto']);

});



Route::put('/update-password', [PasswordController::class, 'update'])
    ->middleware('auth:sanctum');
