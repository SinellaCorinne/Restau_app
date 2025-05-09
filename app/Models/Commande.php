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
        'created_at' => 'datetime',
        'updated_at' => 'datetime'
    ];

    public function user()
    {
        return $this->belongsTo(User::class)->withDefault([
            'nom' => 'Anonyme',
            'prenom' => ''
        ]);
    }

    // Accessor pour le montant total
    public function getMontantTotalAttribute()
    {
        return collect($this->panier)->sum(function ($item) {
            return ($item['prix_unitaire'] ?? 0) * ($item['quantite'] ?? 1);
        });
    }
}
