<?php

namespace App\Http\Requests\Api;

use Illuminate\Foundation\Http\FormRequest;
use Illuminate\Validation\Rules\File;
use App\Helper\CommonHelper;

class CreateProductRequest extends FormRequest
{
    /**
     * Determine if the user is authorized to make this request.
     */
    public function authorize(): bool
    {
        return true;
    }

    /**
     * Get the validation rules that apply to the request.
     *
     * @return array<string, \Illuminate\Contracts\Validation\ValidationRule|array<mixed>|string>
     */
    public function rules(): array
    {
        $rules = [
            'name' => ['required', 'string', 'max:255'],
            'description' => ['required', 'string'],
            'price' => ['required', 'numeric'],
            'image' => ['required', File::types(['jpeg', 'jpg', 'png', 'webp'])->max(500)], // 500 Ko
        ];

        if (in_array($this->method(), ['PUT', 'PATCH'])) {
            $rules['name'][0] = 'sometimes';
            $rules['description'][0] = 'sometimes';
            $rules['price'][0] = 'sometimes';
            $rules['image'] = array_merge(['sometimes'], CommonHelper::getFileValidationRule('image', ['jpeg', 'jpg', 'png', 'webp'], 500)); // 500 Ko
        }

        return $rules;
    }
}
