<!DOCTYPE html>
<html>
<head>
    <title>Réinitialisation</title>
    <style>
        body { font-family: Arial; max-width: 500px; margin: 0 auto; padding: 20px; }
        input { display: block; width: 100%; padding: 10px; margin: 10px 0; }
        button { background: #2563eb; color: white; padding: 10px 15px; border: none; }
    </style>
</head>
<body>
    <h2>Réinitialisation du mot de passe</h2>
    <form method="POST" action="{{ route('password.update') }}">
        @csrf
        <input type="hidden" name="token" value="{{ $token }}">
        <input type="hidden" name="email" value="{{ $email }}">

        <label>Votre email</label>
        <input type="email" name="email" required>

        <label>Nouveau mot de passe</label>
        <input type="password" name="password" required>

        <label>Confirmez le mot de passe</label>
        <input type="password" name="password_confirmation" required>

        <button type="submit">Valider</button>
    </form>
</body>
</html>
