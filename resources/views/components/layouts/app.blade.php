<!DOCTYPE html>
<html lang="{{ str_replace('_', '-', app()->getLocale()) }}">

<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="csrf-token" content="{{ csrf_token() }}">

    <title>{{ config('app.name', 'Laravel') }}</title>

    <!-- Fonts -->
    <link rel="preconnect" href="https://fonts.bunny.net">
    <link href="https://fonts.bunny.net/css?family=figtree:400,500,600&display=swap" rel="stylesheet" />
    <script src="https://cdnjs.cloudflare.com/ajax/libs/flowbite/1.7.0/flowbite.min.js"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">

    <script src="https://cdn.tiny.cloud/1/{{ env('TINY_KEY') }}/tinymce/5/tinymce.min.js" referrerpolicy="origin"></script>

    @vite(['resources/css/app.css', 'resources/js/app.js'])

    <!-- Styles -->
    <style>
        .custom-circle {
            width: 89.71px;
            height: 89.71px;
            border: 10px solid #61A12D;
        }
    </style>
    @livewireStyles
</head>

<body class="text-base antialiased font-inter ">
    {{-- <x-banner /> --}}

    <div class="min-h-screen">
        {{-- @livewire('navigation-menu') --}}
        @include('components.layouts.sidebar')
        <div class="p-4 sm:ml-64">
            <div class="p-4 mx-auto mt-16">
                {{ $slot }}
            </div>
        </div>
    </div>
    @stack('modals')
    @stack('scripts')
    @livewireScripts
</body>

</html>
