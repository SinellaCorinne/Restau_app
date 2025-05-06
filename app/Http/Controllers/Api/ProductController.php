<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Api\Controller;
use App\Models\Product;
use App\Http\Requests\Api\CreateProductRequest;
use App\Http\Resources\ProductResource;
use Illuminate\Support\Facades\Storage;
use App\Helper\CommonHelper;
use Illuminate\Http\JsonResponse;

class ProductController extends Controller
{
    /**
     * Liste tous les produits
     */
    public function index(): JsonResponse
    {
        try {
            $products = Product::all();
            return response()->json([
                'success' => true,
                'data' => ProductResource::collection($products)
            ]);
        } catch (\Exception $e) {
            return $this->serverError($e);
        }
    }

    /**
     * Crée un nouveau produit
     */
    public function store(CreateProductRequest $request): JsonResponse
    {
        try {
            $data = $request->validated();
            
            if ($request->hasFile('image')) {
                $data['image_url'] = $this->storeImage($request->file('image'));
            }

            $product = Product::create($data);

            return response()->json([
                'success' => true,
                'data' => new ProductResource($product),
                'message' => 'Produit créé avec succès'
            ], 201);

        } catch (\Exception $e) {
            return $this->serverError($e);
        }
    }

    /**
     * Affiche un produit
     */
    public function show($id): JsonResponse
    {
        try {
            $product = Product::findOrFail($id);
            return response()->json([
                'success' => true,
                'data' => new ProductResource($product)
            ]);
        } catch (\Exception $e) {
            return $this->notFound();
        }
    }

    /**
     * Met à jour un produit
     */
    public function update(CreateProductRequest $request, $id): JsonResponse
    {
        try {
            $product = Product::findOrFail($id);
            $data = $request->validated();

            if ($request->hasFile('image')) {
                $this->deleteImage($product);
                $data['image_url'] = $this->storeImage($request->file('image'));
            }

            $product->update($data);

            return response()->json([
                'success' => true,
                'data' => new ProductResource($product),
                'message' => 'Produit mis à jour avec succès'
            ]);

        } catch (\Exception $e) {
            return $this->notFound();
        }
    }

    /**
     * Supprime un produit
     */
    public function destroy($id): JsonResponse
    {
        try {
            $product = Product::findOrFail($id);
            $this->deleteImage($product);
            $product->delete();

            return response()->json([
                'success' => true,
                'message' => 'Produit supprimé avec succès'
            ]);
        } catch (\Exception $e) {
            return $this->notFound();
        }
    }

    // =====================================
    // Méthodes privées helpers
    // =====================================

    private function storeImage($file): string
    {
        $path = $file->store('products', 'public');
        return Storage::url($path);
    }

    private function deleteImage(Product $product): void
    {
        if ($product->image_url) {
            $path = str_replace('/storage/', '', $product->image_url);
            Storage::disk('public')->delete($path);
        }
    }

    private function notFound(): JsonResponse
    {
        return response()->json([
            'success' => false,
            'message' => 'Produit non trouvé'
        ], 404);
    }

    private function serverError(\Exception $e): JsonResponse
    {
        return response()->json([
            'success' => false,
            'message' => 'Erreur serveur',
            'error' => config('app.debug') ? $e->getMessage() : null
        ], 500);
    }
}