<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Commande extends Model
{
    use HasFactory;

    protected $fillable = [
        'user_id',
        'adresse',
        'remarque',
        'heure',
        'methode_paiement',
        'details_paiement',
        'panier',
    ];

    protected $casts = [
        'heure' => 'datetime',
        'details_paiement' => 'array',
        'panier' => 'array',
    ];

    public function user()
    {
        return $this->belongsTo(User::class);
    }
}
