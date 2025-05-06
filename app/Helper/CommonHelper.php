<?php

namespace App\Helper;

use Illuminate\Http\UploadedFile;
use Illuminate\Support\Facades\Storage;
use Illuminate\Validation\Rules\File;
use Illuminate\Support\Facades\Log;

class CommonHelper
{
    public static function uploadFile(UploadedFile $file, $path, $oldFile = ''): string
    {
        try {
            if (!empty($file)) {
                // Remove Old file
                if (!empty($oldFile)) {
                    Storage::delete('public/' . $path . '/' . $oldFile); // Delete file from local
                }

                // Upload image
                $path = $file->store('public/' . $path);
                $parts = explode('/', $path);

                return end($parts);
            }

            return '';
        } catch (\Exception $e) {
            Log::error('Error uploading file: ' . $e->getMessage());
            throw $e; // Re-throw the exception to handle it in the controller
        }
    }

    public static function removeOldFile($oldFile): void
    {
        try {
            // Remove Old file
            if (!empty($oldFile)) {
                // Storage::disk('s3')->delete($oldFile);    // Delete file from s3
                Storage::delete($oldFile); // Delete file from local
            }
        } catch (\Exception $e) {
            Log::error('Error removing old file: ' . $e->getMessage());
            // Handle the exception as needed
        }
    }

    public static function getFileValidationRule(string $key, $types, $size = (1 * 500)): array
    {
        if (request()->hasFile($key)) {
            return [File::types($types)->max($size)];
        }

        return ['string'];
    }
}