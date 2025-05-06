<form method="POST" action="{{ route('password.update') }}">
    @csrf
    <input type="hidden" name="token" value="{{ $token }}">
    <input type="email" name="email" value="{{ $email }}" readonly>
    <input type="password" name="password" required>
    <button type="submit">Valider</button>
</form>
