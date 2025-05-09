<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Product extends Model
{
protected $fillable = [
        'name', 'description', 'price', 'image_url', 'menu_category_id'
    ];

    public function menuCategory()
    {
        return $this->belongsTo(MenuCategory::class);
    }

    // Accessor pratique
    public function getCategoryNameAttribute()
    {
        return $this->menuCategory->name ?? 'Non catégorisé';
    }

}
