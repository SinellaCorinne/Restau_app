<div class="w-full px-4 py-8 mx-auto max-w-7xl sm:px-6 lg:px-8">

    @if (session()->has('message'))
    <div class="p-4 mb-4 text-white bg-blue-600 rounded-md shadow-lg">
        {{ session('message') }}
    </div>
    @endif
    <h2 class="text-2xl font-semibold text-gray-900 dark:text-white">Projet</h2>

<button wire:click="create()" class="px-4 py-2 font-bold text-white bg-blue-500 rounded hover:bg-blue-700">
    Create
</button>

<table class="w-full text-sm text-left text-gray-500 dark:text-gray-400">
    <thead class="text-xs text-gray-700 uppercase bg-gray-50 dark:bg-gray-700 dark:text-gray-400">
        <tr>
            <th scope="col" class="px-6 py-3">
                Nom
            </th>
            <th scope="col" class="px-6 py-3">
                Description
            </th>
            <th scope="col" class="px-6 py-3">
                Image
            </th>
            <th scope="col" class="px-6 py-3">
                Actions
            </th>
        </tr>
    </thead>

</table>





</div>
