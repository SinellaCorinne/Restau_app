<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Reservation extends Model
{

public function user()
{
    return $this->belongsTo(User::class);
}
    use HasFactory;

    // Les champs qui peuvent être remplis massivement
    protected $fillable = [
        'nom',
        'prenom',
        'phone',
        'date',
        'time',
        'num_of_people',
        'user_id', // Optionnel, si tu veux lier la réservation à un utilisateur
    ];
}