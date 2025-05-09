<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class MenuCategory extends Model
{
    use HasFactory;

    protected $fillable = ['name', 'slug', 'menu_id', 'order'];

    public function menu()
    {
        return $this->belongsTo(Menu::class);
    }

    public function products()
    {
        return $this->hasMany(Product::class);
    }
}
