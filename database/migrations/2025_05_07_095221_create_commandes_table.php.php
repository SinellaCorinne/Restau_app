<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */public function up(): void
{
    Schema::create('commandes', function (Blueprint $table) {
        $table->id();
        $table->foreignId('user_id')->constrained()->onDelete('cascade');
        $table->string('adresse');
        $table->text('remarque')->nullable();
        $table->dateTime('heure');
        $table->string('methode_paiement');
        $table->json('details_paiement');
        $table->json('panier'); // Contient les articles commandés
        $table->timestamps(); // created_at = date_commande
    });
}


    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('commandes');
    }
};
