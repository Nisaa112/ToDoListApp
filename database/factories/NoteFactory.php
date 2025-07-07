<?php

namespace Database\Factories;

use Illuminate\Database\Eloquent\Factories\Factory;

class NoteFactory extends Factory
{
    public function definition(): array
    {
        return [
            'title' => $this->faker->sentence(),
            'notes' => $this->faker->paragraph(),
            'images' => $this->faker->imageUrl(),
            'file' => $this->faker->filePath()
        ];
    }
}
