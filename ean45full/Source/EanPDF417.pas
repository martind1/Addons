unit EanPdf417;

interface

uses Classes, Windows, Graphics, Dialogs, SysUtils;

resourcestring
        rsBadCharInPDF417='Bad char in PDF417, position %d, char : %s';
type
        psPDF417Mode = (psPDF417Alphanumeric, psPDF417Binary, psPDF417BinaryHex, psPDF417Numeric, psPDF417AutoCode);
        psPDF417ErrorCorrection = (psPDF417AutoEC,psPDF417Error0, psPDF417Error1, psPDF417Error2,
                                   psPDF417Error3, psPDF417Error4, psPDF417Error5,
                                   psPDF417Error6, psPDF417Error7, psPDF417Error8 );



        TInteger5 = array[0..4] of Integer;
        TByte6    = array[0..5] of Byte;

        TIntegerArray = record
             Count : Integer;
             CodeWords: Array [0..2000] of Integer;
        end;


        procedure PaintPDF417(C:TCanvas; R:TRect);

        function Pdf417CodewordToBars(cw:Integer; row:Integer):String;
        function Pdf417OneRowToBars(Row,RowCount,SecurityLevel:Integer; CodeWords:TIntegerArray):String;

        function Base256ToBase900(B6:TByte6):TInteger5;

        procedure PdfBinaryToCodeWords(s:String; var R:TIntegerArray);
        procedure PdfBinaryHexToCodeWords(s:String; var R:TIntegerArray);
        procedure PdfTextToCodeWords(s:String; var R:TIntegerArray);
        procedure PdfNumericToCodeWords(s:String; var R:TIntegerArray);
        function PdfCalcErrorCodes(D:TIntegerArray; ErrorLevel:Integer; ErrCount:Integer):TIntegerArray;



        function Pdf417LeftRowIndicator(RowNumber,NumberOfRows,SecurityLevel,ColumnCount:Integer):Integer;
        function Pdf417RightRowIndicator(RowNumber,NumberOfRows,SecurityLevel,ColumnCount:Integer):Integer;

        procedure GetCompletePDF417LinesBars(S:String; var Cols, Rows:Integer; SecLevel:psPDF417ErrorCorrection;
                  CodingScheme:psPDF417Mode; Truncated:Boolean; L:TStringList);
        function PDF417MinWidth(S:String; Cols, Rows:Integer; SecLevel:psPDF417ErrorCorrection;
                  CodingScheme:psPDF417Mode; Truncated:Boolean):Integer;

implementation

const
	Pdf417_Start	= '11111111010101000';
	Pdf417_Stop     = '111111101000101001';

        Pdf417Bits : array[0..2,0..928] of Word =

             ( ($d5c0, $eaf0, $f57c, $d4e0, $ea78, $f53e, $a8c0, $d470,
                $a860, $5040, $a830, $5020, $adc0, $d6f0, $eb7c, $ace0,
                $d678, $eb3e, $58c0, $ac70, $5860, $5dc0, $aef0, $d77c,
                $5ce0, $ae78, $d73e, $5c70, $ae3c, $5ef0, $af7c, $5e78,
                $af3e, $5f7c, $f5fa, $d2e0, $e978, $f4be, $a4c0, $d270,
                $e93c, $a460, $d238, $4840, $a430, $d21c, $4820, $a418,
                $4810, $a6e0, $d378, $e9be, $4cc0, $a670, $d33c, $4c60,
                $a638, $d31e, $4c30, $a61c, $4ee0, $a778, $d3be, $4e70,
                $a73c, $4e38, $a71e, $4f78, $a7be, $4f3c, $4f1e, $a2c0,
                $d170, $e8bc, $a260, $d138, $e89e, $4440, $a230, $d11c,
                $4420, $a218, $4410, $4408, $46c0, $a370, $d1bc, $4660,
                $a338, $d19e, $4630, $a31c, $4618, $460c, $4770, $a3bc,
                $4738, $a39e, $471c, $47bc, $a160, $d0b8, $e85e, $4240,
                $a130, $d09c, $4220, $a118, $d08e, $4210, $a10c, $4208,
                $a106, $4360, $a1b8, $d0de, $4330, $a19c, $4318, $a18e,
                $430c, $4306, $a1de, $438e, $4140, $a0b0, $d05c, $4120,
                $a098, $d04e, $4110, $a08c, $4108, $a086, $4104, $41b0,
                $4198, $418c, $40a0, $d02e, $a04c, $a046, $4082, $cae0,
                $e578, $f2be, $94c0, $ca70, $e53c, $9460, $ca38, $e51e,
                $2840, $9430, $2820, $96e0, $cb78, $e5be, $2cc0, $9670,
                $cb3c, $2c60, $9638, $2c30, $2c18, $2ee0, $9778, $cbbe,
                $2e70, $973c, $2e38, $2e1c, $2f78, $97be, $2f3c, $2fbe,
                $dac0, $ed70, $f6bc, $da60, $ed38, $f69e, $b440, $da30,
                $ed1c, $b420, $da18, $ed0e, $b410, $da0c, $92c0, $c970,
                $e4bc, $b6c0, $9260, $c938, $e49e, $b660, $db38, $ed9e,
                $6c40, $2420, $9218, $c90e, $6c20, $b618, $6c10, $26c0,
                $9370, $c9bc, $6ec0, $2660, $9338, $c99e, $6e60, $b738,
                $db9e, $6e30, $2618, $6e18, $2770, $93bc, $6f70, $2738,
                $939e, $6f38, $b79e, $6f1c, $27bc, $6fbc, $279e, $6f9e,
                $d960, $ecb8, $f65e, $b240, $d930, $ec9c, $b220, $d918,
                $ec8e, $b210, $d90c, $b208, $b204, $9160, $c8b8, $e45e,
                $b360, $9130, $c89c, $6640, $2220, $d99c, $c88e, $6620,
                $2210, $910c, $6610, $b30c, $9106, $2204, $2360, $91b8,
                $c8de, $6760, $2330, $919c, $6730, $b39c, $918e, $6718,
                $230c, $2306, $23b8, $91de, $67b8, $239c, $679c, $238e,
                $678e, $67de, $b140, $d8b0, $ec5c, $b120, $d898, $ec4e,
                $b110, $d88c, $b108, $d886, $b104, $b102, $2140, $90b0,
                $c85c, $6340, $2120, $9098, $c84e, $6320, $b198, $d8ce,
                $6310, $2108, $9086, $6308, $b186, $6304, $21b0, $90dc,
                $63b0, $2198, $90ce, $6398, $b1ce, $638c, $2186, $6386,
                $63dc, $63ce, $b0a0, $d858, $ec2e, $b090, $d84c, $b088,
                $d846, $b084, $b082, $20a0, $9058, $c82e, $61a0, $2090,
                $904c, $6190, $b0cc, $9046, $6188, $2084, $6184, $2082,
                $20d8, $61d8, $61cc, $61c6, $d82c, $d826, $b042, $902c,
                $2048, $60c8, $60c4, $60c2, $8ac0, $c570, $e2bc, $8a60,
                $c538, $1440, $8a30, $c51c, $1420, $8a18, $1410, $1408,
                $16c0, $8b70, $c5bc, $1660, $8b38, $c59e, $1630, $8b1c,
                $1618, $160c, $1770, $8bbc, $1738, $8b9e, $171c, $17bc,
                $179e, $cd60, $e6b8, $f35e, $9a40, $cd30, $e69c, $9a20,
                $cd18, $e68e, $9a10, $cd0c, $9a08, $cd06, $8960, $c4b8,
                $e25e, $9b60, $8930, $c49c, $3640, $1220, $cd9c, $c48e,
                $3620, $9b18, $890c, $3610, $1208, $3608, $1360, $89b8,
                $c4de, $3760, $1330, $cdde, $3730, $9b9c, $898e, $3718,
                $130c, $370c, $13b8, $89de, $37b8, $139c, $379c, $138e,
                $13de, $37de, $dd40, $eeb0, $f75c, $dd20, $ee98, $f74e,
                $dd10, $ee8c, $dd08, $ee86, $dd04, $9940, $ccb0, $e65c,
                $bb40, $9920, $eedc, $e64e, $bb20, $dd98, $eece, $bb10,
                $9908, $cc86, $bb08, $dd86, $9902, $1140, $88b0, $c45c,
                $3340, $1120, $8898, $c44e, $7740, $3320, $9998, $ccce,
                $7720, $bb98, $ddce, $8886, $7710, $3308, $9986, $7708,
                $1102, $11b0, $88dc, $33b0, $1198, $88ce, $77b0, $3398,
                $99ce, $7798, $bbce, $1186, $3386, $11dc, $33dc, $11ce,
                $77dc, $33ce, $dca0, $ee58, $f72e, $dc90, $ee4c, $dc88,
                $ee46, $dc84, $dc82, $98a0, $cc58, $e62e, $b9a0, $9890,
                $ee6e, $b990, $dccc, $cc46, $b988, $9884, $b984, $9882,
                $b982, $10a0, $8858, $c42e, $31a0, $1090, $884c, $73a0,
                $3190, $98cc, $8846, $7390, $b9cc, $1084, $7388, $3184,
                $1082, $3182, $10d8, $886e, $31d8, $10cc, $73d8, $31cc,
                $10c6, $73cc, $31c6, $10ee, $73ee, $dc50, $ee2c, $dc48,
                $ee26, $dc44, $dc42, $9850, $cc2c, $b8d0, $9848, $cc26,
                $b8c8, $dc66, $b8c4, $9842, $b8c2, $1050, $882c, $30d0,
                $1048, $8826, $71d0, $30c8, $9866, $71c8, $b8e6, $1042,
                $71c4, $30c2, $71c2, $30ec, $71ec, $71e6, $ee16, $dc22,
                $cc16, $9824, $9822, $1028, $3068, $70e8, $1022, $3062,
                $8560, $0a40, $8530, $0a20, $8518, $c28e, $0a10, $850c,
                $0a08, $8506, $0b60, $85b8, $c2de, $0b30, $859c, $0b18,
                $858e, $0b0c, $0b06, $0bb8, $85de, $0b9c, $0b8e, $0bde,
                $8d40, $c6b0, $e35c, $8d20, $c698, $8d10, $c68c, $8d08,
                $c686, $8d04, $0940, $84b0, $c25c, $1b40, $0920, $c6dc,
                $c24e, $1b20, $8d98, $c6ce, $1b10, $0908, $8486, $1b08,
                $8d86, $0902, $09b0, $84dc, $1bb0, $0998, $84ce, $1b98,
                $8dce, $1b8c, $0986, $09dc, $1bdc, $09ce, $1bce, $cea0,
                $e758, $f3ae, $ce90, $e74c, $ce88, $e746, $ce84, $ce82,
                $8ca0, $c658, $9da0, $8c90, $c64c, $9d90, $cecc, $c646,
                $9d88, $8c84, $9d84, $8c82, $9d82, $08a0, $8458, $19a0,
                $0890, $c66e, $3ba0, $1990, $8ccc, $8446, $3b90, $9dcc,
                $0884, $3b88, $1984, $0882, $1982, $08d8, $846e, $19d8,
                $08cc, $3bd8, $19cc, $08c6, $3bcc, $19c6, $08ee, $19ee,
                $3bee, $ef50, $f7ac, $ef48, $f7a6, $ef44, $ef42, $ce50,
                $e72c, $ded0, $ef6c, $e726, $dec8, $ef66, $dec4, $ce42,
                $dec2, $8c50, $c62c, $9cd0, $8c48, $c626, $bdd0, $9cc8,
                $ce66, $bdc8, $dee6, $8c42, $bdc4, $9cc2, $bdc2, $0850,
                $842c, $18d0, $0848, $8426, $39d0, $18c8, $8c66, $7bd0,
                $39c8, $9ce6, $0842, $7bc8, $bde6, $18c2, $7bc4, $086c,
                $18ec, $0866, $39ec, $18e6, $7bec, $39e6, $7be6, $ef28,
                $f796, $ef24, $ef22, $ce28, $e716, $de68, $ef36, $de64,
                $ce22, $de62, $8c28, $c616, $9c68, $8c24, $bce8, $9c64,
                $8c22, $bce4, $9c62, $bce2, $0828, $8416, $1868, $8c36,
                $38e8, $1864, $0822, $79e8, $38e4, $1862, $79e4, $38e2,
                $79e2, $1876, $79f6, $ef12, $de34, $de32, $9c34, $bc74,
                $bc72, $1834, $3874, $78f4, $78f2, $0540, $0520, $8298,
                $0510, $0508, $0504, $05b0, $0598, $058c, $0586, $05dc,
                $05ce, $86a0, $8690, $c34c, $8688, $c346, $8684, $8682,
                $04a0, $8258, $0da0, $86d8, $824c, $0d90, $86cc, $0d88,
                $86c6, $0d84, $0482, $0d82, $04d8, $826e, $0dd8, $86ee,
                $0dcc, $04c6, $0dc6, $04ee, $0dee, $c750, $c748, $c744,
                $c742, $8650, $8ed0, $c76c, $c326, $8ec8, $c766, $8ec4,
                $8642, $8ec2, $0450, $0cd0, $0448, $8226, $1dd0, $0cc8,
                $0444, $1dc8, $0cc4, $0442, $1dc4, $0cc2, $046c, $0cec,
                $0466, $1dec, $0ce6, $1de6, $e7a8, $e7a4, $e7a2, $c728,
                $cf68, $e7b6, $cf64, $c722, $cf62, $8628, $c316, $8e68,
                $c736, $9ee8, $8e64, $8622, $9ee4, $8e62, $9ee2, $0428,
                $8216, $0c68, $8636, $1ce8, $0c64, $0422, $3de8, $1ce4,
                $0c62, $3de4, $1ce2, $0436, $0c76, $1cf6, $3df6, $f7d4,
                $f7d2, $e794, $efb4, $e792, $efb2, $c714, $cf34, $c712,
                $df74, $cf32, $df72, $8614, $8e34, $8612, $9e74, $8e32,
                $bef4 ),

               ($f560, $fab8, $ea40, $f530, $fa9c, $ea20, $f518, $fa8e,
                $ea10, $f50c, $ea08, $f506, $ea04, $eb60, $f5b8, $fade,
                $d640, $eb30, $f59c, $d620, $eb18, $f58e, $d610, $eb0c,
                $d608, $eb06, $d604, $d760, $ebb8, $f5de, $ae40, $d730,
                $eb9c, $ae20, $d718, $eb8e, $ae10, $d70c, $ae08, $d706,
                $ae04, $af60, $d7b8, $ebde, $5e40, $af30, $d79c, $5e20,
                $af18, $d78e, $5e10, $af0c, $5e08, $af06, $5f60, $afb8,
                $d7de, $5f30, $af9c, $5f18, $af8e, $5f0c, $5fb8, $afde,
                $5f9c, $5f8e, $e940, $f4b0, $fa5c, $e920, $f498, $fa4e,
                $e910, $f48c, $e908, $f486, $e904, $e902, $d340, $e9b0,
                $f4dc, $d320, $e998, $f4ce, $d310, $e98c, $d308, $e986,
                $d304, $d302, $a740, $d3b0, $e9dc, $a720, $d398, $e9ce,
                $a710, $d38c, $a708, $d386, $a704, $a702, $4f40, $a7b0,
                $d3dc, $4f20, $a798, $d3ce, $4f10, $a78c, $4f08, $a786,
                $4f04, $4fb0, $a7dc, $4f98, $a7ce, $4f8c, $4f86, $4fdc,
                $4fce, $e8a0, $f458, $fa2e, $e890, $f44c, $e888, $f446,
                $e884, $e882, $d1a0, $e8d8, $f46e, $d190, $e8cc, $d188,
                $e8c6, $d184, $d182, $a3a0, $d1d8, $e8ee, $a390, $d1cc,
                $a388, $d1c6, $a384, $a382, $47a0, $a3d8, $d1ee, $4790,
                $a3cc, $4788, $a3c6, $4784, $4782, $47d8, $a3ee, $47cc,
                $47c6, $47ee, $e850, $f42c, $e848, $f426, $e844, $e842,
                $d0d0, $e86c, $d0c8, $e866, $d0c4, $d0c2, $a1d0, $d0ec,
                $a1c8, $d0e6, $a1c4, $a1c2, $43d0, $a1ec, $43c8, $a1e6,
                $43c4, $43c2, $43ec, $43e6, $e828, $f416, $e824, $e822,
                $d068, $e836, $d064, $d062, $a0e8, $d076, $a0e4, $a0e2,
                $41e8, $a0f6, $41e4, $41e2, $e814, $e812, $d034, $d032,
                $a074, $a072, $e540, $f2b0, $f95c, $e520, $f298, $f94e,
                $e510, $f28c, $e508, $f286, $e504, $e502, $cb40, $e5b0,
                $f2dc, $cb20, $e598, $f2ce, $cb10, $e58c, $cb08, $e586,
                $cb04, $cb02, $9740, $cbb0, $e5dc, $9720, $cb98, $e5ce,
                $9710, $cb8c, $9708, $cb86, $9704, $9702, $2f40, $97b0,
                $cbdc, $2f20, $9798, $cbce, $2f10, $978c, $2f08, $9786,
                $2f04, $2fb0, $97dc, $2f98, $97ce, $2f8c, $2f86, $2fdc,
                $2fce, $f6a0, $fb58, $6bf0, $f690, $fb4c, $69f8, $f688,
                $fb46, $68fc, $f684, $f682, $e4a0, $f258, $f92e, $eda0,
                $e490, $fb6e, $ed90, $f6cc, $f246, $ed88, $e484, $ed84,
                $e482, $ed82, $c9a0, $e4d8, $f26e, $dba0, $c990, $e4cc,
                $db90, $edcc, $e4c6, $db88, $c984, $db84, $c982, $db82,
                $93a0, $c9d8, $e4ee, $b7a0, $9390, $c9cc, $b790, $dbcc,
                $c9c6, $b788, $9384, $b784, $9382, $b782, $27a0, $93d8,
                $c9ee, $6fa0, $2790, $93cc, $6f90, $b7cc, $93c6, $6f88,
                $2784, $6f84, $2782, $27d8, $93ee, $6fd8, $27cc, $6fcc,
                $27c6, $6fc6, $27ee, $f650, $fb2c, $65f8, $f648, $fb26,
                $64fc, $f644, $647e, $f642, $e450, $f22c, $ecd0, $e448,
                $f226, $ecc8, $f666, $ecc4, $e442, $ecc2, $c8d0, $e46c,
                $d9d0, $c8c8, $e466, $d9c8, $ece6, $d9c4, $c8c2, $d9c2,
                $91d0, $c8ec, $b3d0, $91c8, $c8e6, $b3c8, $d9e6, $b3c4,
                $91c2, $b3c2, $23d0, $91ec, $67d0, $23c8, $91e6, $67c8,
                $b3e6, $67c4, $23c2, $67c2, $23ec, $67ec, $23e6, $67e6,
                $f628, $fb16, $62fc, $f624, $627e, $f622, $e428, $f216,
                $ec68, $f636, $ec64, $e422, $ec62, $c868, $e436, $d8e8,
                $c864, $d8e4, $c862, $d8e2, $90e8, $c876, $b1e8, $d8f6,
                $b1e4, $90e2, $b1e2, $21e8, $90f6, $63e8, $21e4, $63e4,
                $21e2, $63e2, $21f6, $63f6, $f614, $617e, $f612, $e414,
                $ec34, $e412, $ec32, $c834, $d874, $c832, $d872, $9074,
                $b0f4, $9072, $b0f2, $20f4, $61f4, $20f2, $61f2, $f60a,
                $e40a, $ec1a, $c81a, $d83a, $903a, $b07a, $e2a0, $f158,
                $f8ae, $e290, $f14c, $e288, $f146, $e284, $e282, $c5a0,
                $e2d8, $f16e, $c590, $e2cc, $c588, $e2c6, $c584, $c582,
                $8ba0, $c5d8, $e2ee, $8b90, $c5cc, $8b88, $c5c6, $8b84,
                $8b82, $17a0, $8bd8, $c5ee, $1790, $8bcc, $1788, $8bc6,
                $1784, $1782, $17d8, $8bee, $17cc, $17c6, $17ee, $f350,
                $f9ac, $35f8, $f348, $f9a6, $34fc, $f344, $347e, $f342,
                $e250, $f12c, $e6d0, $e248, $f126, $e6c8, $f366, $e6c4,
                $e242, $e6c2, $c4d0, $e26c, $cdd0, $c4c8, $e266, $cdc8,
                $e6e6, $cdc4, $c4c2, $cdc2, $89d0, $c4ec, $9bd0, $89c8,
                $c4e6, $9bc8, $cde6, $9bc4, $89c2, $9bc2, $13d0, $89ec,
                $37d0, $13c8, $89e6, $37c8, $9be6, $37c4, $13c2, $37c2,
                $13ec, $37ec, $13e6, $37e6, $fba8, $75f0, $bafc, $fba4,
                $74f8, $ba7e, $fba2, $747c, $743e, $f328, $f996, $32fc,
                $f768, $fbb6, $76fc, $327e, $f764, $f322, $767e, $f762,
                $e228, $f116, $e668, $e224, $eee8, $f776, $e222, $eee4,
                $e662, $eee2, $c468, $e236, $cce8, $c464, $dde8, $cce4,
                $c462, $dde4, $cce2, $dde2, $88e8, $c476, $99e8, $88e4,
                $bbe8, $99e4, $88e2, $bbe4, $99e2, $bbe2, $11e8, $88f6,
                $33e8, $11e4, $77e8, $33e4, $11e2, $77e4, $33e2, $77e2,
                $11f6, $33f6, $fb94, $72f8, $b97e, $fb92, $727c, $723e,
                $f314, $317e, $f734, $f312, $737e, $f732, $e214, $e634,
                $e212, $ee74, $e632, $ee72, $c434, $cc74, $c432, $dcf4,
                $cc72, $dcf2, $8874, $98f4, $8872, $b9f4, $98f2, $b9f2,
                $10f4, $31f4, $10f2, $73f4, $31f2, $73f2, $fb8a, $717c,
                $713e, $f30a, $f71a, $e20a, $e61a, $ee3a, $c41a, $cc3a,
                $dc7a, $883a, $987a, $b8fa, $107a, $30fa, $71fa, $70be,
                $e150, $f0ac, $e148, $f0a6, $e144, $e142, $c2d0, $e16c,
                $c2c8, $e166, $c2c4, $c2c2, $85d0, $c2ec, $85c8, $c2e6,
                $85c4, $85c2, $0bd0, $85ec, $0bc8, $85e6, $0bc4, $0bc2,
                $0bec, $0be6, $f1a8, $f8d6, $1afc, $f1a4, $1a7e, $f1a2,
                $e128, $f096, $e368, $e124, $e364, $e122, $e362, $c268,
                $e136, $c6e8, $c264, $c6e4, $c262, $c6e2, $84e8, $c276,
                $8de8, $84e4, $8de4, $84e2, $8de2, $09e8, $84f6, $1be8,
                $09e4, $1be4, $09e2, $1be2, $09f6, $1bf6, $f9d4, $3af8,
                $9d7e, $f9d2, $3a7c, $3a3e, $f194, $197e, $f3b4, $f192,
                $3b7e, $f3b2, $e114, $e334, $e112, $e774, $e332, $e772,
                $c234, $c674, $c232, $cef4, $c672, $cef2, $8474, $8cf4,
                $8472, $9df4, $8cf2, $9df2, $08f4, $19f4, $08f2, $3bf4,
                $19f2, $3bf2, $7af0, $bd7c, $7a78, $bd3e, $7a3c, $7a1e,
                $f9ca, $397c, $fbda, $7b7c, $393e, $7b3e, $f18a, $f39a,
                $f7ba, $e10a, $e31a, $e73a, $ef7a, $c21a, $c63a, $ce7a,
                $defa, $843a, $8c7a, $9cfa, $bdfa, $087a, $18fa, $39fa,
                $7978, $bcbe, $793c, $791e, $38be, $79be, $78bc, $789e,
                $785e, $e0a8, $e0a4, $e0a2, $c168, $e0b6, $c164, $c162,
                $82e8, $c176, $82e4, $82e2, $05e8, $82f6, $05e4, $05e2,
                $05f6, $f0d4, $0d7e, $f0d2, $e094, $e1b4, $e092, $e1b2,
                $c134, $c374, $c132, $c372, $8274, $86f4, $8272, $86f2,
                $04f4, $0df4, $04f2, $0df2, $f8ea, $1d7c, $1d3e, $f0ca,
                $f1da, $e08a, $e19a, $e3ba, $c11a, $c33a, $c77a, $823a,
                $867a, $8efa, $047a, $0cfa, $1dfa, $3d78, $9ebe, $3d3c,
                $3d1e, $1cbe, $3dbe, $7d70, $bebc, $7d38, $be9e, $7d1c,
                $7d0e, $3cbc, $7dbc, $3c9e, $7d9e, $7cb8, $be5e, $7c9c,
                $7c8e, $3c5e, $7cde, $7c5c, $7c4e, $7c2e, $c0b4, $c0b2,
                $8174, $8172, $02f4, $02f2, $e0da, $c09a, $c1ba, $813a,
                $837a, $027a, $06fa, $0ebe, $1ebc, $1e9e, $3eb8, $9f5e,
                $3e9c, $3e8e, $1e5e, $3ede, $7eb0, $bf5c, $7e98, $bf4e,
                $7e8c, $7e86, $3e5c, $7edc, $3e4e, $7ece, $7e58, $bf2e,
                $7e4c, $7e46, $3e2e, $7e6e, $7e2c, $7e26, $0f5e, $1f5c,
                $1f4e, $3f58, $9fae, $3f4c, $3f46, $1f2e, $3f6e, $3f2c,
                $3f26 ),
               ($abe0, $d5f8, $53c0, $a9f0, $d4fc, $51e0, $a8f8, $d47e,
                $50f0, $a87c, $5078, $fad0, $5be0, $adf8, $fac8, $59f0,
                $acfc, $fac4, $58f8, $ac7e, $fac2, $587c, $f5d0, $faec,
                $5df8, $f5c8, $fae6, $5cfc, $f5c4, $5c7e, $f5c2, $ebd0,
                $f5ec, $ebc8, $f5e6, $ebc4, $ebc2, $d7d0, $ebec, $d7c8,
                $ebe6, $d7c4, $d7c2, $afd0, $d7ec, $afc8, $d7e6, $afc4,
                $4bc0, $a5f0, $d2fc, $49e0, $a4f8, $d27e, $48f0, $a47c,
                $4878, $a43e, $483c, $fa68, $4df0, $a6fc, $fa64, $4cf8,
                $a67e, $fa62, $4c7c, $4c3e, $f4e8, $fa76, $4efc, $f4e4,
                $4e7e, $f4e2, $e9e8, $f4f6, $e9e4, $e9e2, $d3e8, $e9f6,
                $d3e4, $d3e2, $a7e8, $d3f6, $a7e4, $a7e2, $45e0, $a2f8,
                $d17e, $44f0, $a27c, $4478, $a23e, $443c, $441e, $fa34,
                $46f8, $a37e, $fa32, $467c, $463e, $f474, $477e, $f472,
                $e8f4, $e8f2, $d1f4, $d1f2, $a3f4, $a3f2, $42f0, $a17c,
                $4278, $a13e, $423c, $421e, $fa1a, $437c, $433e, $f43a,
                $e87a, $d0fa, $4178, $a0be, $413c, $411e, $41be, $40bc,
                $409e, $2bc0, $95f0, $cafc, $29e0, $94f8, $ca7e, $28f0,
                $947c, $2878, $943e, $283c, $f968, $2df0, $96fc, $f964,
                $2cf8, $967e, $f962, $2c7c, $2c3e, $f2e8, $f976, $2efc,
                $f2e4, $2e7e, $f2e2, $e5e8, $f2f6, $e5e4, $e5e2, $cbe8,
                $e5f6, $cbe4, $cbe2, $97e8, $cbf6, $97e4, $97e2, $b5e0,
                $daf8, $ed7e, $69c0, $b4f0, $da7c, $68e0, $b478, $da3e,
                $6870, $b43c, $6838, $b41e, $681c, $25e0, $92f8, $c97e,
                $6de0, $24f0, $927c, $6cf0, $b67c, $923e, $6c78, $243c,
                $6c3c, $241e, $6c1e, $f934, $26f8, $937e, $fb74, $f932,
                $6ef8, $267c, $fb72, $6e7c, $263e, $6e3e, $f274, $277e,
                $f6f4, $f272, $6f7e, $f6f2, $e4f4, $edf4, $e4f2, $edf2,
                $c9f4, $dbf4, $c9f2, $dbf2, $93f4, $93f2, $65c0, $b2f0,
                $d97c, $64e0, $b278, $d93e, $6470, $b23c, $6438, $b21e,
                $641c, $640e, $22f0, $917c, $66f0, $2278, $913e, $6678,
                $b33e, $663c, $221e, $661e, $f91a, $237c, $fb3a, $677c,
                $233e, $673e, $f23a, $f67a, $e47a, $ecfa, $c8fa, $d9fa,
                $91fa, $62e0, $b178, $d8be, $6270, $b13c, $6238, $b11e,
                $621c, $620e, $2178, $90be, $6378, $213c, $633c, $211e,
                $631e, $21be, $63be, $6170, $b0bc, $6138, $b09e, $611c,
                $610e, $20bc, $61bc, $209e, $619e, $60b8, $b05e, $609c,
                $608e, $205e, $60de, $605c, $604e, $15e0, $8af8, $c57e,
                $14f0, $8a7c, $1478, $8a3e, $143c, $141e, $f8b4, $16f8,
                $8b7e, $f8b2, $167c, $163e, $f174, $177e, $f172, $e2f4,
                $e2f2, $c5f4, $c5f2, $8bf4, $8bf2, $35c0, $9af0, $cd7c,
                $34e0, $9a78, $cd3e, $3470, $9a3c, $3438, $9a1e, $341c,
                $340e, $12f0, $897c, $36f0, $1278, $893e, $3678, $9b3e,
                $363c, $121e, $361e, $f89a, $137c, $f9ba, $377c, $133e,
                $373e, $f13a, $f37a, $e27a, $e6fa, $c4fa, $cdfa, $89fa,
                $bae0, $dd78, $eebe, $74c0, $ba70, $dd3c, $7460, $ba38,
                $dd1e, $7430, $ba1c, $7418, $ba0e, $740c, $32e0, $9978,
                $ccbe, $76e0, $3270, $993c, $7670, $bb3c, $991e, $7638,
                $321c, $761c, $320e, $760e, $1178, $88be, $3378, $113c,
                $7778, $333c, $111e, $773c, $331e, $771e, $11be, $33be,
                $77be, $72c0, $b970, $dcbc, $7260, $b938, $dc9e, $7230,
                $b91c, $7218, $b90e, $720c, $7206, $3170, $98bc, $7370,
                $3138, $989e, $7338, $b99e, $731c, $310e, $730e, $10bc,
                $31bc, $109e, $73bc, $319e, $739e, $7160, $b8b8, $dc5e,
                $7130, $b89c, $7118, $b88e, $710c, $7106, $30b8, $985e,
                $71b8, $309c, $719c, $308e, $718e, $105e, $30de, $71de,
                $70b0, $b85c, $7098, $b84e, $708c, $7086, $305c, $70dc,
                $304e, $70ce, $7058, $b82e, $704c, $7046, $302e, $706e,
                $702c, $7026, $0af0, $857c, $0a78, $853e, $0a3c, $0a1e,
                $0b7c, $0b3e, $f0ba, $e17a, $c2fa, $85fa, $1ae0, $8d78,
                $c6be, $1a70, $8d3c, $1a38, $8d1e, $1a1c, $1a0e, $0978,
                $84be, $1b78, $093c, $1b3c, $091e, $1b1e, $09be, $1bbe,
                $3ac0, $9d70, $cebc, $3a60, $9d38, $ce9e, $3a30, $9d1c,
                $3a18, $9d0e, $3a0c, $3a06, $1970, $8cbc, $3b70, $1938,
                $8c9e, $3b38, $191c, $3b1c, $190e, $3b0e, $08bc, $19bc,
                $089e, $3bbc, $199e, $3b9e, $bd60, $deb8, $ef5e, $7a40,
                $bd30, $de9c, $7a20, $bd18, $de8e, $7a10, $bd0c, $7a08,
                $bd06, $7a04, $3960, $9cb8, $ce5e, $7b60, $3930, $9c9c,
                $7b30, $bd9c, $9c8e, $7b18, $390c, $7b0c, $3906, $7b06,
                $18b8, $8c5e, $39b8, $189c, $7bb8, $399c, $188e, $7b9c,
                $398e, $7b8e, $085e, $18de, $39de, $7bde, $7940, $bcb0,
                $de5c, $7920, $bc98, $de4e, $7910, $bc8c, $7908, $bc86,
                $7904, $7902, $38b0, $9c5c, $79b0, $3898, $9c4e, $7998,
                $bcce, $798c, $3886, $7986, $185c, $38dc, $184e, $79dc,
                $38ce, $79ce, $78a0, $bc58, $de2e, $7890, $bc4c, $7888,
                $bc46, $7884, $7882, $3858, $9c2e, $78d8, $384c, $78cc,
                $3846, $78c6, $182e, $386e, $78ee, $7850, $bc2c, $7848,
                $bc26, $7844, $7842, $382c, $786c, $3826, $7866, $7828,
                $bc16, $7824, $7822, $3816, $7836, $0578, $82be, $053c,
                $051e, $05be, $0d70, $86bc, $0d38, $869e, $0d1c, $0d0e,
                $04bc, $0dbc, $049e, $0d9e, $1d60, $8eb8, $c75e, $1d30,
                $8e9c, $1d18, $8e8e, $1d0c, $1d06, $0cb8, $865e, $1db8,
                $0c9c, $1d9c, $0c8e, $1d8e, $045e, $0cde, $1dde, $3d40,
                $9eb0, $cf5c, $3d20, $9e98, $cf4e, $3d10, $9e8c, $3d08,
                $9e86, $3d04, $3d02, $1cb0, $8e5c, $3db0, $1c98, $8e4e,
                $3d98, $9ece, $3d8c, $1c86, $3d86, $0c5c, $1cdc, $0c4e,
                $3ddc, $1cce, $3dce, $bea0, $df58, $efae, $be90, $df4c,
                $be88, $df46, $be84, $be82, $3ca0, $9e58, $cf2e, $7da0,
                $3c90, $9e4c, $7d90, $becc, $9e46, $7d88, $3c84, $7d84,
                $3c82, $7d82, $1c58, $8e2e, $3cd8, $1c4c, $7dd8, $3ccc,
                $1c46, $7dcc, $3cc6, $7dc6, $0c2e, $1c6e, $3cee, $7dee,
                $be50, $df2c, $be48, $df26, $be44, $be42, $3c50, $9e2c,
                $7cd0, $3c48, $9e26, $7cc8, $be66, $7cc4, $3c42, $7cc2,
                $1c2c, $3c6c, $1c26, $7cec, $3c66, $7ce6, $be28, $df16,
                $be24, $be22, $3c28, $9e16, $7c68, $3c24, $7c64, $3c22,
                $7c62, $1c16, $3c36, $7c76, $be14, $be12, $3c14, $7c34,
                $3c12, $7c32, $02bc, $029e, $06b8, $835e, $069c, $068e,
                $025e, $06de, $0eb0, $875c, $0e98, $874e, $0e8c, $0e86,
                $065c, $0edc, $064e, $0ece, $1ea0, $8f58, $c7ae, $1e90,
                $8f4c, $1e88, $8f46, $1e84, $1e82, $0e58, $872e, $1ed8,
                $8f6e, $1ecc, $0e46, $1ec6, $062e, $0e6e, $1eee, $9f50,
                $cfac, $9f48, $cfa6, $9f44, $9f42, $1e50, $8f2c, $3ed0,
                $9f6c, $8f26, $3ec8, $1e44, $3ec4, $1e42, $3ec2, $0e2c,
                $1e6c, $0e26, $3eec, $1e66, $3ee6, $dfa8, $efd6, $dfa4,
                $dfa2, $9f28, $cf96, $bf68, $9f24, $bf64, $9f22, $bf62,
                $1e28, $8f16, $3e68, $1e24, $7ee8, $3e64, $1e22, $7ee4,
                $3e62, $7ee2, $0e16, $1e36, $3e76, $7ef6, $df94, $df92,
                $9f14, $bf34, $9f12, $bf32, $1e14, $3e34, $1e12, $7e74,
                $3e32, $7e72, $df8a, $9f0a, $bf1a, $1e0a, $3e1a, $7e3a,
                $035c, $034e, $0758, $83ae, $074c, $0746, $032e, $076e,
                $0f50, $87ac, $0f48, $87a6, $0f44, $0f42, $072c, $0f6c,
                $0726, $0f66, $8fa8, $c7d6, $8fa4, $8fa2, $0f28, $8796,
                $1f68, $8fb6, $1f64, $0f22, $1f62, $0716, $0f36, $1f76,
                $cfd4, $cfd2, $8f94, $9fb4, $8f92, $9fb2, $0f14, $1f34,
                $0f12, $3f74, $1f32, $3f72, $cfca, $8f8a, $9f9a, $0f0a,
                $1f1a, $3f3a, $03ac, $03a6, $07a8, $83d6, $07a4, $07a2,
                $0396, $07b6, $87d4, $87d2, $0794, $0fb4, $0792, $0fb2,
                $c7ea ));


        ErrorTable0 : array [0..1] of word =(27,917);
        ErrorTable1 : array [0..3] of word =(522,568,723,809);
        ErrorTable2 : array [0..7] of word =(237,308,436,284,646,653,428,379);
        ErrorTable3 : array [0..15] of word =
                (274,562,232,755,599,524,801,132,295,116,442,428,295, 42,176, 65);
        ErrorTable4 : array [0..31] of word =
                (361,575,922,525,176,586,640,321,536,742,677,742,687,284,193,517,
                 273,494,263,147,593,800,571,320,803,133,231,390,685,330, 63,410);

        ErrorTable5 : array [0..63]  of word =
                (539,422,  6, 93,862,771,453,106,610,287,107,505,733,877,381,612,
                 723,476,462,172,430,609,858,822,543,376,511,400,672,762,283,184,
                 440, 35,519, 31,460,594,225,535,517,352,605,158,651,201,488,502,
                 648,733,717, 83,404, 97,280,771,840,629,  4,381,843,623,264,543
                );
        ErrorTable6 : array [0..127] of word =
                (521,310, 864, 547, 858, 580, 296, 379,  53, 779, 897, 444, 400, 925, 749, 415,
                 822, 93, 217, 208, 928, 244, 583, 620, 246, 148, 447, 631, 292, 908, 490, 704,
                 516,258, 457, 907, 594, 723, 674, 292, 272,  96, 684, 432, 686, 606, 860, 569,
                 193,219, 129, 186, 236, 287, 192, 775, 278, 173,  40, 379, 712, 463, 646, 776,
                 171,491, 297, 763, 156, 732,  95, 270, 447,  90, 507,  48, 228, 821, 808, 898,
                 784,663, 627, 378, 382, 262, 380, 602, 754, 336,  89, 614,  87, 432, 670, 616,
                 157,374, 242, 726, 600, 269, 375, 898, 845, 454, 354, 130, 814, 587, 804,  34,
                 211,330, 539, 297, 827, 865,  37, 517, 834, 315, 550,  86, 801,   4, 108, 539
                );
        ErrorTable7 : array [0..255] of word =
                (524, 894,  75, 766, 882, 857,  74, 204,  82, 586, 708, 250, 905, 786, 138, 720,
                 858, 194, 311, 913, 275, 190, 375, 850, 438, 733, 194, 280, 201, 280, 828, 757,
                 710, 814, 919,  89,  68, 569,  11, 204, 796, 605, 540, 913, 801, 700, 799, 137,
                 439, 418, 592, 668, 353, 859, 370, 694, 325, 240, 216, 257, 284, 549, 209, 884,
                 315,  70, 329, 793, 490, 274, 877, 162, 749, 812, 684, 461, 334, 376, 849, 521,
                 307, 291, 803, 712,  19, 358, 399, 908, 103, 511,  51,   8, 517, 225, 289, 470,
                 637, 731,  66, 255, 917, 269, 463, 830, 730, 433, 848, 585, 136, 538, 906,  90,
                   2, 290, 743, 199, 655, 903, 329,  49, 802, 580, 355, 588, 188, 462,  10, 134,
                 628, 320, 479, 130, 739,  71, 263, 318, 374, 601, 192, 605, 142, 673, 687, 234,
                 722, 384, 177, 752, 607, 640, 455, 193, 689, 707, 805, 641,  48,  60, 732, 621,
                 895, 544, 261, 852, 655, 309, 697, 755, 756,  60, 231, 773, 434, 421, 726, 528,
                 503, 118,  49, 795,  32, 144, 500, 238, 836, 394, 280, 566, 319,   9, 647, 550,
                  73, 914, 342, 126,  32, 681, 331, 792, 620,  60, 609, 441, 180, 791, 893, 754,
                 605, 383, 228, 749, 760, 213,  54, 297, 134,  54, 834, 299, 922, 191, 910, 532,
                 609, 829, 189,  20, 167,  29, 872, 449,  83, 402,  41, 656, 505, 579, 481, 173,
                 404, 251, 688,  95, 497, 555, 642, 543, 307, 159, 924, 558, 648,  55, 497,  10
                );
        ErrorTable8 : array [0..511] of word =
                (352,  77, 373, 504,  35, 599, 428, 207, 409, 574, 118, 498, 285, 380, 350, 492,
                 197, 265, 920, 155, 914, 299, 229, 643, 294, 871, 306,  88,  87, 193, 352, 781,
                 846,  75, 327, 520, 435, 543, 203, 666, 249, 346, 781, 621, 640, 268, 794, 534,
                 539, 781, 408, 390, 644, 102, 476, 499, 290, 632, 545,  37, 858, 916, 552,  41,
                 542, 289, 122, 272, 383, 800, 485,  98, 752, 472, 761, 107, 784, 860, 658, 741,
                 290, 204, 681, 407, 855,  85,  99,  62, 482, 180,  20, 297, 451, 593, 913, 142,
                 808, 684, 287, 536, 561,  76, 653, 899, 729, 567, 744, 390, 513, 192, 516, 258,
                 240, 518, 794, 395, 768, 848,  51, 610, 384, 168, 190, 826, 328, 596, 786, 303,
                 570, 381, 415, 641, 156, 237, 151, 429, 531, 207, 676, 710,  89, 168, 304, 402,
                  40, 708, 575, 162, 864, 229,  65, 861, 841, 512, 164, 477, 221,  92, 358, 785,
                 288, 357, 850, 836, 827, 736, 707,  94,   8, 494, 114, 521,   2, 499, 851, 543,
                 152, 729, 771,  95, 248, 361, 578, 323, 856, 797, 289,  51, 684, 466, 533, 820,
                 669,  45, 902, 452, 167, 342, 244, 173,  35, 463, 651,  51, 699, 591, 452, 578,
                  37, 124, 298, 332, 552,  43, 427, 119, 662, 777, 475, 850, 764, 364, 578, 911,
                 283, 711, 472, 420, 245, 288, 594, 394, 511, 327, 589, 777, 699, 688,  43, 408,
                 842, 383, 721, 521, 560, 644, 714, 559,  62, 145, 873, 663, 713, 159, 672, 729,
                 624,  59, 193, 417, 158, 209, 563, 564, 343, 693, 109, 608, 563, 365, 181, 772,
                 677, 310, 248, 353, 708, 410, 579, 870, 617, 841, 632, 860, 289, 536,  35, 777,
                 618, 586, 424, 833,  77, 597, 346, 269, 757, 632, 695, 751, 331, 247, 184,  45,
                 787, 680,  18,  66, 407, 369,  54, 492, 228, 613, 830, 922, 437, 519, 644, 905,
                 789, 420, 305, 441, 207, 300, 892, 827, 141, 537, 381, 662, 513,  56, 252, 341,
                 242, 797, 838, 837, 720, 224, 307, 631,  61,  87, 560, 310, 756, 665, 397, 808,
                 851, 309, 473, 795, 378,  31, 647, 915, 459, 806, 590, 731, 425, 216, 548, 249,
                 321, 881, 699, 535, 673, 782, 210, 815, 905, 303, 843, 922, 281,  73, 469, 791,
                 660, 162, 498, 308, 155, 422, 907, 817, 187,  62,  16, 425, 535, 336, 286, 437,
                 375, 273, 610, 296, 183, 923, 116, 667, 751, 353,  62, 366, 691, 379, 687, 842,
                  37, 357, 720, 742, 330,   5,  39, 923, 311, 424, 242, 749, 321,  54, 669, 316,
                 342, 299, 534, 105, 667, 488, 640, 672, 576, 540, 316, 486, 721, 610,  46, 656,
                 447, 171, 616, 464, 190, 531, 297, 321, 762, 752, 533, 175, 134,  14, 381, 433,
                 717,  45, 111,  20, 596, 284, 736, 138, 646, 411, 877, 669, 141, 919,  45, 780,
                 407, 164, 332, 899, 165, 726, 600, 325, 498, 655, 357, 752, 768, 223, 849, 647,
                  63, 310, 863, 251, 366, 304, 282, 738, 675, 410, 389, 244,  31, 121, 303, 263
                );


procedure PaintPDF417(C:TCanvas; R:TRect);
begin
        C.Pen.Width:=5;
        C.Pen.Color := clBlack;
        C.MoveTo(R.Left,R.Top);
        C.LineTo(R.Right,R.Bottom);
end;


function Pdf417CodewordToBars(cw:Integer; row:Integer):String;
var w:word;
    i:Integer;
begin
    w      := Pdf417Bits[row mod 3][cw];
    Result := StringOfChar('1',17);
    for i:=17 downto 2 do begin
        if (w and $1)=0 then
                Result[i]:='0';
        w := w shr 1;
    end;
end;


function Base256ToBase900(B6:TByte6):TInteger5;
var i:Integer;
    a, b: Array[0..4] of LongInt;
    carry, rem, temp : LongInt;
begin
    for i:=0 to 4 do begin
        a[i] := 0;
        b[i] := 0;
    end;

    // bytes 0-2
    rem := 65536*B6[0]+256*B6[1]+B6[2];
    i:=0;
    while rem>899 do begin
          a[i] := rem mod 900;
          rem      := rem div 900;
          Inc(i);
    end;
    a[i] := rem;

    // bytes 3-5
    rem := 65536*B6[3]+256*B6[4]+B6[5];
    i:=0;
    while rem>899 do begin
          b[i] := rem mod 900;
          rem      := rem div 900;
          Inc(i);
    end;
    b[i] := rem;


    Temp      := 316*a[0]+b[0];
    Result[4] := temp mod 900;
    carry     := temp div 900;

    temp      := (b[1]+641*a[0]+316*a[1]+carry);
    Result[3] := temp mod 900;
    carry     := temp div 900;

    temp      := (b[2]+20*a[0]+641*a[1]+316*a[2]+carry);
    Result[2] := temp mod 900;
    carry     := temp div 900;

    temp      := (b[3]+20*a[1]+641*a[2]+carry);
    Result[1] := temp mod 900;
    carry     := temp div 900;

    temp      := (20*a[2]+carry);
    Result[0] := temp mod 900;
end;

procedure GetValueMode(c:Char; var code:char; var mode:Integer);
var v:byte;
begin
    v:=0;
    case c of
        'A'..'Z' : begin v:=Ord(C)-Ord('A'); mode:=8; end;
        'a'..'z' : begin v:=Ord(C)-Ord('a'); mode:=4; end;
        '0'..'9' : begin v:=Ord(C)-Ord('0'); mode:=2; end;
        '&'      : begin v:=10; mode:=2; end;
        #13      : begin v:=11; mode:=3; end;
        #9       : begin v:=12; mode:=3; end;
        ','      : begin v:=13; mode:=3; end;
        ':'      : begin v:=14; mode:=3; end;
        '#'      : begin v:=15; mode:=2; end;
        '-'      : begin v:=16; mode:=3; end;
        '.'      : begin v:=17; mode:=3; end;
        '$'      : begin v:=18; mode:=3; end;
        '/'      : begin v:=19; mode:=3; end;
        '+'      : begin v:=20; mode:=2; end;
        '%'      : begin v:=21; mode:=2; end;
        '*'      : begin v:=22; mode:=3; end;
        '='      : begin v:=23; mode:=2; end;
        '^'      : begin v:=24; mode:=2; end;
        ' '      : begin v:=26; mode:=14; end;

        ';'      : begin v:= 0; mode:=1; end;
        '<'      : begin v:= 1; mode:=1; end;
        '>'      : begin v:= 2; mode:=1; end;
        '@'      : begin v:= 3; mode:=1; end;
        '['      : begin v:= 4; mode:=1; end;
        '\'      : begin v:= 5; mode:=1; end;
        ']'      : begin v:= 6; mode:=1; end;
        '_'      : begin v:= 7; mode:=1; end;
        '`'      : begin v:= 8; mode:=1; end;
        '~'      : begin v:= 9; mode:=1; end;
        '!'      : begin v:=10; mode:=1; end;
        #10      : begin v:=15; mode:=1; end;
        '"'      : begin v:=20; mode:=1; end;
        '|'      : begin v:=21; mode:=1; end;
        '('      : begin v:=23; mode:=1; end;
        ')'      : begin v:=24; mode:=1; end;
        '?'      : begin v:=25; mode:=1; end;
        '{'      : begin v:=26; mode:=1; end;
        '}'      : begin v:=27; mode:=1; end;
        ''''     : begin v:=28; mode:=1; end;
        else     mode:=-1;
    end;
    Code:=Char(v);
end;


procedure PdfTextToCodeWords(s:String; var R:TIntegerArray);
const latch_to_num=#28;
      switch_to_punct=#29;
      latch_to_punct=#25;
      latch_to_lower=#27;
      switch_to_alpha=#27;
      latch_to_alpha_num=#28;
      latch_fr_mixed_to_alpha=#28;
      latch_to_alpha_punct=#29;
var code, code_temp : char;
    last_mode, mode, mode_temp, mode_prev : Integer;
    temp        : String;
    i           : Integer;
    single_capital, Num : Boolean;
begin
    // Result.CodeWords[Result.Count] := 900;
    // Inc(Result.Count);

    temp      := '';
    i         := 1;
    Last_Mode := 8;

    while i<=Length(s) do begin
        GetValueMode(s[i], code, mode);
        Inc(i);

        if (Last_Mode and Mode)<>0 then begin
            temp:=temp+code;
            if (Mode=8) or (Mode=4) or (Mode=2) or (Mode=1) then
                Last_Mode := Mode;
        end else begin
            mode_prev := Last_Mode;
            // change subtype
            if (Mode_Prev and 8)<>0 then begin
                Num := False;
                if (Mode and 2)<>0 then begin
                    Num:=True;
                    temp := temp + latch_to_num + code;
                    Last_Mode := 2;
                end;
                if (not Num) and ((Mode and 1)<>0) then begin
                    if i<=Length(s) then
                        GetValueMode(s[i], code_temp, mode_temp)
                    else
                        mode_temp := 0;

                    if (mode_temp and 1)=0 then begin
                        temp:=temp+switch_to_punct+code;
                    end else begin
                        temp:=temp+latch_to_num+latch_to_punct+code;
                        last_mode := 1;
                    end;
                end;

                if (Mode and 4)<>0 then begin
                    temp:=temp+latch_to_lower+code;
                    last_mode:=mode;
                end;
            end;



            if (Mode_Prev and 4)<>0 then begin
                num:=False;
                if (Mode and 8)<>0 then begin
                    if i<=Length(s) then
                        GetValueMode(s[i], code_temp, mode_temp)
                    else
                        mode_temp := 0;

                    single_capital := (mode_temp and 8)=0;
                    if single_capital then
                        temp:=temp+switch_to_alpha+code
                    else begin
                        temp:=temp+latch_to_num+latch_to_alpha_num+code;
                        Last_Mode := 8;
                    end;
                end else
                if (Mode and 2)<>0 then begin
                    // num:=True;
                    temp:=temp+latch_to_num+code;
                    Last_Mode := 2;
                end else
                if (not Num) and ((Mode and 1)<>0) then begin
                    if i<=Length(s) then
                        GetValueMode(s[i], code_temp, mode_temp)
                    else
                        mode_temp := 0;

                    if (mode_temp and 1)=0 then begin
                        temp:=temp+switch_to_punct+code;
                    end else begin
                        temp:=temp+latch_to_num+latch_to_punct+code;
                        last_mode := 1;
                    end;
                end;
            end;


            if (Mode_Prev and 2)<>0 then begin
                if (Mode and 8)<>0 then begin
                    temp:=temp+latch_fr_mixed_to_alpha+Code;
                    Last_Mode := 8;
                end else
                if (Mode and 4)<>0 then begin
                    temp:=temp+latch_to_lower+code;
                    Last_Mode := 4;
                end else
                if (Mode and 1)<>0 then begin
                    if i<=Length(s) then
                        GetValueMode(s[i], code_temp, mode_temp)
                    else
                        mode_temp := 0;

                    if (mode_temp and 1)=0 then begin
                        temp:=temp+switch_to_punct+code;
                    end else begin
                        temp:=temp+latch_to_punct+code;
                        last_mode := 1;
                    end;
                end;
            end;


            if ((Mode_Prev and 1)<>0) and ((Mode_Prev and 2)=0) then begin
                if (Mode and 8)<>0 then begin
                    temp:=temp+latch_to_alpha_punct+code;
                    Last_Mode := 8;
                end else
                if (Mode and 4)<>0 then begin
                    temp:=temp+latch_to_alpha_punct+latch_to_lower+code;
                    Last_Mode := 4;
                end else
                if (Mode and 2)<>0 then begin
                    temp:=temp+latch_to_alpha_punct+latch_to_num+code;
                    Last_Mode := 2;
                end
            end;
        end;
    end;


    if (Length(temp) mod 2)<>0 then temp:=temp+#29;

    i:=1;
    while i<Length(temp) do begin
        R.CodeWords[R.Count] := 30*Ord(temp[i])+Ord(temp[i+1]);
        Inc(R.Count);
        Inc(i,2);
    end;
end;

procedure PdfNumericToCodeWords(s:String; var R:TIntegerArray);
    procedure PDF417NumericPart(ss:String; var R:TIntegerArray);
    var x,i:Integer;
        ss1:string;
        v:array [1..30] of Integer;
        v1:Integer;
    begin
        for i:=1 to 30 do v[i]:=-1;
        v1:=0;
        i :=1;
        while (ss<>'') and (ss<>'0') do begin
            ss1:='';
            x:=0;
            while (x<900) and (i<=Length(ss)) do begin
                x:=10*x+Ord(ss[i])-Ord('0');
                Inc(i);
            end;
            while (i<=Length(ss)+1) do begin
                    ss1:=ss1+Char(Ord('0')+x div 900);
                    if i<=Length(ss) then begin
                        x:=10*(x mod 900)+Ord(ss[i])-Ord('0');
                        Inc(i);
                    end else Break;
            end;
            Inc(v1);
            v[v1]:=x mod 900;
            ss := ss1;
            i  := 1;

        end;
        for i:=30 downto 1 do
            if v[i]>=0 then begin
                Inc(R.Count);
                R.CodeWords[R.Count-1] := v[i];
            end;
    end;
begin
    s:='1'+s;

    // swith to numeric mode
    Inc(R.Count);
    R.CodeWords[R.Count-1] := 902;
    while Length(s)>44 do begin
        PDF417NumericPart(Copy(s,1,44), R);
        s:=Copy(s,45,Length(s)-44);
    end;
    if s<>'' then
        PDF417NumericPart(s, R);
end;

procedure PdfBinaryToCodeWords(s:String; var R:TIntegerArray);
var i,j:Integer;
    B  :TByte6;
    V  :TInteger5;
begin
    i:=1;
    if Length(s) mod 6 = 0 then
        R.CodeWords[R.Count] := 924
    else
        R.CodeWords[R.Count] := 901;
    Inc(R.Count);

    while Length(s)-i>=5 do begin
        for j:=0 to 5 do
                B[j]:=Ord(s[i+j]);
        V := Base256ToBase900(B);

        for j:=0 to 4 do begin
                R.CodeWords[R.Count] := V[j];
                Inc(R.Count);
        end;
        Inc(i,6);
    end;

    while i<=Length(s) do begin
        R.CodeWords[R.Count] := Ord(s[i]);
        Inc(R.Count);
        Inc(i);
    end;
end;


procedure PdfBinaryHexToCodeWords(s:String; var R:TIntegerArray);
var temp:String;
    i:Integer;
    j:Integer;
    function HexDigit(c:Char):Integer;
    begin
         Result := 0;
         case c of
              '0'..'9' : Result := Ord(c)-Ord('0');
              'A'..'F' : Result := Ord(c)-Ord('A')+10;
              'a'..'f' : Result := Ord(c)-Ord('a')+10;
         end;
    end;
begin
     if (Length(s) mod 2)<>0 then
        s:='0'+s;
     temp := '';
     i    := 1;
     while i<Length(s) do begin
           j:=16*HexDigit(s[i])+HexDigit(s[i]);
           temp:=temp+Char(j);
           Inc(i,2);
     end;

     PdfBinaryToCodeWords(temp, R);
end;

function Pdf417LeftRowIndicator(RowNumber,NumberOfRows,SecurityLevel,ColumnCount:Integer):Integer;
begin
        Result := 0;
        case (RowNumber mod 3) of
                0 : Result := 30*(RowNumber div 3)+(NumberOfRows-1) div 3;
                1 : Result := 30*(RowNumber div 3)+(SecurityLevel*3) + (NumberOfRows-1) mod 3;
                2 : Result := 30*(RowNumber div 3)+(ColumnCount-1);
        end;
end;

function Pdf417RightRowIndicator(RowNumber,NumberOfRows,SecurityLevel,ColumnCount:Integer):Integer;
begin
        Result := 0;
        case (RowNumber mod 3) of
                0 : Result := 30*(RowNumber div 3)+(ColumnCount-1);
                1 : Result := 30*(RowNumber div 3)+(NumberOfRows-1) div 3;
                2 : Result := 30*(RowNumber div 3)+(SecurityLevel*3) + (NumberOfRows-1) mod 3;
        end;
end;



function Pdf417OneRowToBars(row,RowCount,SecurityLevel:Integer; CodeWords:TIntegerArray):String;
var li,ri:word;
    i : Integer;
begin
        li := Pdf417LeftRowIndicator(Row,RowCount,SecurityLevel,CodeWords.Count);
        ri := Pdf417RightRowIndicator(Row,RowCount,SecurityLevel,CodeWords.Count);

        for i:=0 to CodeWords.Count-1 do
                Result := Result + Pdf417CodewordToBars(CodeWords.CodeWords[i], row);

        Result := PDF417_Start + Pdf417CodewordToBars(li, row);
        Result := Result + Pdf417CodewordToBars(ri, row) + PDF417_Stop;
end;


function PdfCalcErrorCodes(D:TIntegerArray; ErrorLevel:Integer; ErrCount:Integer):TIntegerArray;
var i,j:Integer;
    t1,t2,t3:Integer;
    aj,a0:integer;
    ck_m1:Integer;
begin
        // initialization
        Result.Count:=ErrCount;
        for i:=0 to ErrCount-1 do
                Result.CodeWords[i] := 0;

        for i:=0 to D.Count-1 do begin
                ck_m1:= Result.CodeWords[Result.Count-1];
                t1 := (D.CodeWords[i]+ck_m1) mod 929;

                for j:=Result.Count-1 downto 1 do begin
                        aj := 0;
                        case ErrorLevel of
                                0 : aj := ErrorTable0[j];
                                1 : aj := ErrorTable1[j];
                                2 : aj := ErrorTable2[j];
                                3 : aj := ErrorTable3[j];
                                4 : aj := ErrorTable4[j];
                                5 : aj := ErrorTable5[j];
                                6 : aj := ErrorTable6[j];
                                7 : aj := ErrorTable7[j];
                                8 : aj := ErrorTable8[j];
                        end;

                        t2 := (t1*aj) mod 929;
                        t3 := 929 - t2;
                        Result.CodeWords[j] := (Result.CodeWords[j-1]+t3) mod 929;
                end;
                a0 := 0;
                case ErrorLevel of
                        0 : a0 := ErrorTable0[0];
                        1 : a0 := ErrorTable1[0];
                        2 : a0 := ErrorTable2[0];
                        3 : a0 := ErrorTable3[0];
                        4 : a0 := ErrorTable4[0];
                        5 : a0 := ErrorTable5[0];
                        6 : a0 := ErrorTable6[0];
                        7 : a0 := ErrorTable7[0];
                        8 : a0 := ErrorTable8[0];
                end;

                t2 := (t1*a0) mod 929;
                t3 := 929 - t2;
                Result.CodeWords[0] := t3 mod 929;
        end;

        for j:=0 to Result.Count-1 do
                if Result.CodeWords[j]<>0 then
                    Result.CodeWords[j]:= 929-Result.CodeWords[j];
end;


procedure PDF417Check(s:String; CodingScheme:psPDF417Mode);
var i:Integer;
    ok:Boolean;
begin
     ok:=True;
     i:=0;
     case CodingScheme of
          psPDF417Alphanumeric  :
               for i:=1 to Length(s) do
                   if not CharInSet(s[i], ['A'..'Z','a'..'z','0'..'9','&',#9,#13,',',':','#',
                      '-','.','$','/','+','%','*','=','^',' ',';','<','>','@',
                      '[','\',']','_','`','~','!',#10,'"','|',
                      '(',')','?','{','}', '''' ]) then begin
                      ok:=False;
                      Break;
                   end;
          psPDF417BinaryHex     :
               for i:=1 to Length(s) do
                   if not CharInSet(s[i], ['0'..'9','A'..'F','a'..'f']) then begin
                      ok:=False;
                      Break;
                   end;
          psPDF417Numeric       :
               for i:=1 to Length(s) do
                   if not CharInSet(s[i], ['0'..'9']) then begin
                      ok:=False;
                      Break;
                   end;
     end;

     if not OK then
        Raise Exception.Create(Format(rsBadCharInPDF417,[i,s[i]]));
end;

procedure PDF417PrepareCodeWords(S:String; var Cols, Rows:Integer; SecLevel:psPDF417ErrorCorrection;
                  CodingScheme:psPDF417Mode; var D:TIntegerArray; var ErrCount,SecurityLevel:Integer);
var i :Integer;
begin
        D.Count:=1;
        PDF417Check(s, CodingScheme);

        case CodingScheme of
                psPDF417Alphanumeric  : PdfTextToCodeWords(S,D );
                psPDF417Binary        : PdfBinaryToCodeWords(S, D);
                psPDF417BinaryHex     : PdfBinaryHexToCodeWords(S, D);
                psPDF417Numeric       : PdfNumericToCodeWords(S, D);
                psPDF417AutoCode      : PdfBinaryToCodeWords(S, D);
        end;

        D.CodeWords[0] := D.Count;
        if SecLevel=psPDF417AutoEC then
        case D.Count of
                1..40   : SecLevel:=psPDF417Error2;
                41..160 : SecLevel:=psPDF417Error3;
               161..320 : SecLevel:=psPDF417Error4;
               321..863 : SecLevel:=psPDF417Error5;
               else       SecLevel:=psPDF417Error6;
        end;

        SecurityLevel := Integer(SecLevel)-1;

        ErrCount := 1;
        for i:=1 to SecurityLevel+1 do
                ErrCount := 2*ErrCount;


        if (Cols<=0) and (Rows<=0) then Cols:=20;
        if Cols>0 then begin
           while (((D.Count+ErrCount) mod Cols)<>0) do begin
                Inc(D.Count);
                D.CodeWords[D.Count-1] := 900;
           end;
           Rows := (D.Count+ErrCount) div Cols;
        end
        else if Rows<>0 then begin
           while (((D.Count+ErrCount) mod Rows)<>0) do begin
                Inc(D.Count);
                D.CodeWords[D.Count-1] := 900;
           end;
           Cols := (D.Count+ErrCount) div Rows;
        end;
        D.CodeWords[0] := D.Count;
end;


procedure GetCompletePDF417LinesBars(S:String; var Cols, Rows:Integer; SecLevel:psPDF417ErrorCorrection;
        CodingScheme:psPDF417Mode; Truncated:Boolean; L:TStringList);
var D,E:TIntegerArray;
    ErrCount:Integer;
    i, j, CodeWordsInRow, tmp :Integer;
    one_line:String;
    SecurityLevel : Integer;
begin
        PDF417PrepareCodeWords(S, Cols, Rows, SecLevel, CodingScheme, D, ErrCount,SecurityLevel);

        E:=PdfCalcErrorCodes(D,SecurityLevel, ErrCount);
        for i:=0 to E.Count-1 do
                D.CodeWords[D.Count+i] := E.CodeWords[E.Count-1-i];
        Inc(D.Count, E.Count);

        CodeWordsInRow := D.Count div Rows;
        for i:=0 to Rows-1 do begin
             one_line := Pdf417_Start;
             tmp := Pdf417LeftRowIndicator(i,Rows,SecurityLevel,CodeWordsInRow);
             one_line := one_line + Pdf417CodewordToBars(tmp, i);

             for j:=0 to CodeWordsInRow-1 do begin
                tmp      := D.CodeWords[i*CodeWordsInRow+j];
                one_line := one_line + Pdf417CodewordToBars(tmp, i);
             end;

             if Truncated then
                one_line:=one_line+'1'
             else begin
                tmp := Pdf417RightRowIndicator(i,Rows,SecurityLevel,CodeWordsInRow);
                one_line := one_line + Pdf417CodewordToBars(tmp, i);
                one_line := one_line + Pdf417_Stop;
             end;

             L.Add(one_line);
        end;
end;


function PDF417MinWidth(S:String; Cols, Rows:Integer; SecLevel:psPDF417ErrorCorrection;
                  CodingScheme:psPDF417Mode; Truncated:Boolean):Integer;
var D:TIntegerArray;
    ErrCount,SecurityLevel:Integer;
begin
        PDF417PrepareCodeWords(S, Cols, Rows, SecLevel, CodingScheme, D, ErrCount,SecurityLevel);
        if Truncated then
           Result := Length(Pdf417_Start)+(Cols+2)*17 + Length(Pdf417_Stop)
        else
           Result := Length(Pdf417_Start)+(Cols+1)*17 + 1;
end;

end.








