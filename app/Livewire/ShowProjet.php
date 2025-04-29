<?php

namespace App\Livewire;
use App\Livewire\Forms\ProjetForm;
use \App\Models\Projet;
use Livewire\Component;


class ShowProjet extends Component
{
    public ProjetForm $form;
    public Projet $deleting;
        public $isEditMode= false;
        public $isDeleteMode= false;
        public $ationTitle= '';
        public $selectedProjet;

        public function createProjet()
        {
            $this-> isEditMode= true;
            $this-> actionTitle='Ajouter un projet';
        }
        public function save()
        {
            if ($this->form && $this->form->Projet && $this->form->Projet->id)
            {
                $this->form->update(); }
                else
                {
                    $this->form->store();
                }
                $this->isEditMode= false;
        }

        public function editProjet(Projet $Projet)
        {
            $this->isEditMode = true;
            $this->deleting = $Projet;
            $this->selectedProjet = $this->deleting->nom;
            $this->selectedProjet = $this->deleting->description;
            $this->selectedProjet = $this->deleting->image;
            $this->selectedProjet = $this->deleting->url;
            

            $this->actionTitle = 'Modifier Projet';
        }


        public function deleteProjet(Projet $Projet)
        {
            $this->isDeleteMode = true;
            $this->deleting = $Projet;
            $this->selectedProjet = $this->deleting->nom;
            $this->selectedProjet = $this->deleting->description;
            $this->selectedProjet = $this->deleting->image;
            $this->selectedProjet = $this->deleting->url;
            $this->actionTitle = 'Supression Projet';
        }


        public function deleteSelected()
        {
            $this->deleting->delete();
            $this->isDeleteMode = false;
        }


        public function cancel()
        {
            $this->isEditMode = false;
            $this->isDeleteMode = false;
        }

    public function render()
    {
        return view('livewire.show-projet');
    }
}
