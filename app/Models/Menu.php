<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Menu extends Model
{
    use HasFactory;

    protected $fillable = ['name', 'description', 'is_active'];

    public function categories()
    {
        return $this->hasMany(MenuCategory::class);
    }

    public function products()
    {
        return $this->hasManyThrough(Product::class, MenuCategory::class);
    }
}
