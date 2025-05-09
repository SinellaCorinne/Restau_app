<?php

namespace Database\Seeders;

use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;

class InitMenuCategoriesSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
public function run()
{
    // 1. Créer le menu principal
    $menu = \App\Models\Menu::create([
        'name' => 'Menu Principal',
        'description' => 'Notre menu complet'
    ]);

    // 2. Créer les catégories
    $categories = [
        ['name' => 'Entrées', 'slug' => 'entrees', 'order' => 1],
        ['name' => 'Plats Principaux', 'slug' => 'plats', 'order' => 2],
        ['name' => 'Desserts', 'slug' => 'desserts', 'order' => 3],
        ['name' => 'Boissons', 'slug' => 'boissons', 'order' => 4]
    ];

    foreach ($categories as $cat) {
        $menu->categories()->create($cat);
    }

    // 3. Mettre à jour les produits existants (optionnel)
    $defaultCategory = $menu->categories()->first();
    \App\Models\Product::query()->update([
        'menu_category_id' => $defaultCategory->id
    ]);
}
}