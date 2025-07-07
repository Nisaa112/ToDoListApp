<?php

namespace Database\Seeders;

use App\Models\User;
use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Str;

class userSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        User::insert([
            [
                'name' => 'Dafarina',
                'serial_number' => '001',
                'email' => 'dafarina@example.com',
                'email_verified_at' => now(),
                'password' => Hash::make('123456'),
                'remember_token' => Str::random(10),
            ],
            [
                'name' => 'Azmi',
                'email' => 'azmi@example.com',
                'email_verified_at' => now(),
                'password' => Hash::make('456'),
                'remember_token' => Str::random(10),
            ],
        ]);
    }
}
