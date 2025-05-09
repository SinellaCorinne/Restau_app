<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use App\Models\MenuCategory;
use App\Models\Product;


class ProductSeeder extends Seeder
{


public function run()
{
    // Récupérez les catégories existantes
    $entrees = MenuCategory::where('slug', 'entrees')->first();
    $plats = MenuCategory::where('slug', 'plats')->first();
    $desserts = MenuCategory::where('slug', 'desserts')->first();
    $boissons = MenuCategory::where('slug', 'boissons')->first();

    // Entrées
    $entrees->products()->createMany([
        [
            'name' => 'Salade César',
            'description' => 'Salade fraîche avec poulet grillé et sauce césar',
            'price' => 8.50,
            'image_url' => 'images/salade-cesar.jpg'
        ],
        [
            'name' => 'Bruschetta',
            'description' => 'Toasts à la tomate et basilic',
            'price' => 6.00,
            'image_url' => 'images/bruschetta.jpg'
        ]
    ]);

    // Plats principaux
    $plats->products()->createMany([
        [
            'name' => 'Pizza Margherita',
            'description' => 'Pizza classique avec mozzarella et basilic',
            'price' => 12.00,
            'image_url' => 'images/pizza-margherita.jpg'
        ],
        [
            'name' => 'Poulet rôti',
            'description' => 'Poulet rôti avec légumes de saison',
            'price' => 15.00,
            'image_url' => 'images/poulet-roti.jpg'
        ]
    ]);

    // Desserts
    $desserts->products()->createMany([
        [
            'name' => 'Tiramisu',
            'description' => 'Dessert italien au café',
            'price' => 7.00,
            'image_url' => 'images/tiramisu.jpg'
        ],
        [
            'name' => 'Fondant au chocolat',
            'description' => 'Gâteau moelleux avec coeur coulant',
            'price' => 6.50,
            'image_url' => 'images/fondant-chocolat.jpg'
        ]
    ]);

    // Boissons
    $boissons->products()->createMany([
        [
            'name' => 'Jus d\'orange pressé',
            'description' => '100% pur jus fraîchement pressé',
            'price' => 4.00,
            'image_url' => 'images/jus-orange.jpg'
        ],
        [
            'name' => 'Vin rouge maison',
            'description' => 'Verre de vin rouge de la région',
            'price' => 5.50,
            'image_url' => 'images/vin-rouge.jpg'
        ]
    ]);
}
}
