<?php

namespace App\Notifications;

use Illuminate\Notifications\Notification;
use Illuminate\Notifications\Messages\MailMessage;

class ResetPasswordNotification extends Notification
{
    public $token;

    public function __construct($token)
    {
        $this->token = $token;
    }

    public function via($notifiable)
    {
        return ['mail'];
    }

    public function toMail($notifiable)
    {
        $url = url('/api/reset-password-preview?token=' . $this->token . '&email=' . urlencode($notifiable->email));

        return (new MailMessage)
            ->subject('Réinitialisation du mot de passe')
            ->line('Cliquez sur le bouton ci-dessous pour réinitialiser votre mot de passe.')
            ->action('Réinitialiser le mot de passe', $url)
            ->line('Si vous n\'avez pas demandé cette réinitialisation, ignorez simplement cet email.');
    }

}
