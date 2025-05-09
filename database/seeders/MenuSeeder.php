<?php

namespace Database\Seeders;

use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;
use App\Models\Menu;
use App\Models\MenuCategory;

class MenuSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
   // database/seeders/MenuSeeder.php
public function run()
{
    $menu = Menu::create([
        'name' => 'Carte Principale',
        'description' => 'Notre menu principal'
    ]);

    $categories = [
        ['name' => 'Entrées', 'slug' => 'entrees'],
        ['name' => 'Plats Principaux', 'slug' => 'plats'],
        ['name' => 'Desserts', 'slug' => 'desserts'],
        ['name' => 'Boissons', 'slug' => 'boissons']
    ];

    foreach ($categories as $cat) {
        $menu->categories()->create($cat);
    }
}
}
