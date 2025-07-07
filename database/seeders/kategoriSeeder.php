<?php

namespace Database\Seeders;

use App\Models\Category;
use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;

class kategoriSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        Category::insert([
            [
                'id' => '1',
                'name' => 'Semua'
            ],
            [
                'id' => '2',
                'name' => 'Pribadi'
            ],
            [
                'id' => '3',
                'name' => 'Pekerjaan Kantor'
            ],
        ]);
    }
}
