<?php

namespace App\Http\Resources;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class ProductResource extends JsonResource
{
    /**
     * Transform the resource into an array.
     *
     * @return array<string, mixed>
     */
    public function toArray(Request $request): array
    {
        return [
            'id' => $this->id, // Important pour les opérations CRUD
            'name' => $this->name,
            'description' => $this->description,
            'price' => (float) $this->price, // Conversion explicite
            'image_url' => $this->image_url ? asset($this->image_url) : null,
            'created_at' => $this->created_at->toDateTimeString(), // Optionnel
            'updated_at' => $this->updated_at->toDateTimeString(), // Optionnel
        ];
    }
}