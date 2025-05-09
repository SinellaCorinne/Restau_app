<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
public function up()
{
    Schema::table('products', function (Blueprint $table) {
        // D'abord ajouter la colonne sans la contrainte
        $table->unsignedBigInteger('menu_category_id')->nullable()->after('image_url');

        // Puis ajouter la contrainte après avoir peuplé les données
        $table->foreign('menu_category_id')
              ->references('id')
              ->on('menu_categories')
              ->onDelete('set null');
    });
}

public function down()
{
    Schema::table('products', function (Blueprint $table) {
        $table->dropForeign(['menu_category_id']);
        $table->dropColumn('menu_category_id');
    });
}
};
