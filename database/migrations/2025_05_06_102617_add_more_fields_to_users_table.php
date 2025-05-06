<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::table('users', function (Blueprint $table) {
            $table->string('adresse')->nullable();
            $table->string('ville')->nullable();
            $table->string('preferences')->nullable();
            $table->string('photo')->nullable(); // chemin vers l'image
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
{
    Schema::table('users', function (Blueprint $table) {
        $table->dropColumn(['adresse', 'ville', 'preferences', 'photo']);
    });
}
};
