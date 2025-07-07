@include('templates.header')
@include('templates.navbar')
@include('templates.sidebar')

<div class="content-wrapper">
    <section class="content pt-4 px-3">
        <div class="container">
            <h3>Tambah Serial Number</h3>

            {{-- Alert jika sukses --}}
            @if(session('success'))
            <div class="alert alert-success alert-dismissible fade in mt-3" role="alert" id="popup-alert-success">
                <button type="button" class="close" data-dismiss="alert" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
                {{ session('success') }}
            </div>
            @endif

            {{-- Alert jika error --}}
            @if(session('error'))
            <div class="alert alert-danger alert-dismissible fade in mt-3" role="alert" id="popup-alert-error">
                <button type="button" class="close" data-dismiss="alert" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
                {{ session('error') }}
            </div>
            @endif

            {{-- Alert validasi --}}
            @if($errors->any())
            <div class="alert alert-danger alert-dismissible fade in mt-3" role="alert" id="popup-alert-error">
                <button type="button" class="close" data-dismiss="alert" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
                <ul class="mb-0">
                    @foreach($errors->all() as $error)
                    <li>{{ $error }}</li>
                    @endforeach
                </ul>
            </div>
            @endif

            {{-- Form Tambah Serial --}}
            <form action="{{ route('serial.store') }}" method="POST">
                @csrf
                <div class="form-group mb-3">
                    <label for="user_id">User</label>
                    <select name="user_id" class="form-control" required>
                        <option value="">-- Pilih User --</option>
                        @foreach($users as $user)
                        <option value="{{ $user->id }}">{{ $user->name }} ({{ $user->email }})</option>
                        @endforeach
                    </select>
                </div>

                <div class="form-group mb-3">
                    <label for="serial_number">Serial Number</label>
                    <input type="text" class="form-control" name="serial_number" required>
                </div>

                <div class="form-group mb-3">
                    <label for="password">Kata Sandi</label>
                    <input type="password" class="form-control" name="password" required>
                </div>

                <button type="submit" class="btn btn-primary">Simpan</button>
            </form>
        </div>
    </section>
</div>

@include('templates.footer')

{{-- Script: auto-hide alert --}}
<script>
    window.onload = function () {
        const successAlert = document.getElementById('popup-alert-success');
        const errorAlert = document.getElementById('popup-alert-error');

        if (successAlert) {
            setTimeout(() => {
                $(successAlert).alert('close');
            }, 3000);
        }

        if (errorAlert) {
            setTimeout(() => {
                $(errorAlert).alert('close');
            }, 3000);
        }
    }
</script>
