<?php

namespace App\Livewire\Forms;

use Livewire\Attributes\Validate;
use Livewire\Form;

class ProjetForm extends Form
{
    public ?Projet $Projet = null;

    public $nom;
    public $description;
    public $image;
    public $url;


    protected function rules ()
    {
        return
        [
            'nom' => ['required', 'string', 'max:255'],        ]
    ;}

    public function store ()
    {

        $this->validate();

        Projet::create
        ([
            'nom' => $this->nom,
            'description' => $this->description,
            'image' => $this->image,
            'url' => $this->url,
        ]);

    }

    public function render()
    {
        return view('livewire.forms.projet-form');
    }

    public function update ()
    {
        $this->validate();
        $this->Projet->update
        ([
            'nom' => $this->nom,
            'description' => $this->description,
            'image' => $this->image,
            'url' => $this->url,
        ]);
    }

    public function setProjet (Projet $Projet)
    {
        $this->Projet = $Projet;
        $this->nom = $Projet->nom;
        $this->description = $Projet->description;
        $this->image = $Projet->image;
        $this->url = $Projet->url;
    }

    public function save ()
    {
        if ($this->Projet && $this->Projet->id)
        {
            $this->update();
        }
        else
        {
            $this->store();
        }
    }

    public function cancel ()
    {
        $this->Projet = null;
    }

    
}