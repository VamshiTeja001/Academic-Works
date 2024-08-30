#!/usr/bin/perl
use strict;
use warnings;

my $filename = 'Q4FinalExam.txt';

# Generate all possible binary combinations for 8 inputs (A1 to B4)
for (my $i = 0; $i <= 255; $i++) {
    open(my $fh, '<', $filename) or die "Could not open file '$filename' $!";

    my $binary = sprintf("%08b", $i);
    my @binary_array = split //, $binary;

    while (my $line = <$fh>) {
        chomp($line);
        if ($line =~ /^V\d+\s+(A\d+)\s+0\s+dc\s+pulse\((.*?)\)$/) {
            my $input_name = $1;
            my $original_params = $2;
            
            my @params = split /\s+/, $original_params;

            
            if (@binary_array) {
                $params[1] = shift(@binary_array) * 1.8; 
            } else {
                warn "Not enough bits in binary_array for line: $line\n";
            }

            my $new_line = "V$input_name 0 dc pulse(" . join(' ', @params) . ")";
            print "$new_line\n";
        }
    }

    close $fh;
}

# Execute ngspice
my $ngspice_command = "ngspice -b $filename";
`$ngspice_command`;
