<?php

namespace App\Exports;

use App\Models\Menu;
use Maatwebsite\Excel\Concerns\FromCollection;
use Maatwebsite\Excel\Concerns\ShouldAutoSize;
use Maatwebsite\Excel\Concerns\WithHeadings;

class MenuExport implements FromCollection, WithHeadings, ShouldAutoSize
{
    /**
    * @return \Illuminate\Support\Collection
    */
    public function collection()
    {
        return Menu::all();
    }

    public function headings(): array
    {
        return [
            'ID',
            'Nama Menu',
            'Harga',
            'Deskripsi',
            'Ketersediaan',
            'Tanggal Ditambahkan',
            'Tanggal Edit'
        ];
    }
}
