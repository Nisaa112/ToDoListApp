@include('templates.header')
@include('templates.navbar')
@include('templates.sidebar')

<div class="content-wrapper">
    <section class="content pt-4 px-3">
        <div class="container">
            <h3>Tambah User Baru</h3>

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

            {{-- Form --}}
            <form action="{{ route('user.store') }}" method="POST" enctype="multipart/form-data">
                @csrf
                <div class="form-group mb-3">
                    <label for="name">Nama</label>
                    <input type="text" class="form-control" name="name" required>
                </div>

                <div class="form-group mb-3">
                    <label for="email">Email</label>
                    <input type="email" class="form-control" name="email" required>
                </div>

                <div class="form-group mb-3">
                    <label for="photo_profile">Foto Profil</label>
                    <input type="file" class="form-control" name="photo_profile">
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
