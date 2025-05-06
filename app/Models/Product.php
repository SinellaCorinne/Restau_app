<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Product extends Model
{
    protected $fillable = [
        'name',
        'description',
        'price',
        'image_url' // Ajouté pour stocker le chemin de l'image
    ];

    protected $casts = [
        'price' => 'decimal:2'
    ];
}