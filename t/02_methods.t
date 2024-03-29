use strict;
use warnings;
use Test::More tests => 4;
use Statistics::TopK;

{
    my $counter = Statistics::TopK->new(10);
    is_deeply([$counter->top], [], 'stream containing no elements');
}

{
    my $counter = Statistics::TopK->new(10);
    for my $elem ( ('a') x 100 ) {
        $counter->add($elem);
    }
    is_deeply(
        [$counter->top], ['a'], 'stream containing one distinct element'
    );
}

{
    my $counter = Statistics::TopK->new(10);
    for my $elem (1 .. 100) {
        $counter->add($elem);
    }
    is_deeply(
        [ sort { $a <=> $b } $counter->top ],
        [91 .. 100],
        'stream containing all distinct elements'
    );
}

{
    my $counter = Statistics::TopK->new(4);
    my @stream = qw(
        1 2 1 1 1 1 1 1 9 1 1 3 1 1 3 4 1 5 1 4 1 1 1 2 1 1 1 1 1 1 1 1 1 2 1
        1 2 9 1 1 1 1 2 1 4 1 6 1 3 1 4 1 1 1 7 2 5 1 1 1 4 1 1 1 4 1 1 3 9
        8 1 7 1 2 1 1 1 1 1 1 8 1 1 1 1 1 2 1 1 1 1 2 4 9 5 1 1 1 1 2 1 3 1 1
        1 1 5 2 3 2 1 1 5 3 2 1 7 1 6 1 1 1 1 2 1 2 1 3 1 1 1 2 4 1 3 3 6 6
        1 1 3 4 1 1 1 2 1 3 1 1 6 1 1 1 1 2 8 3 1 2 1 1 1 1 1 6 1 6 1 1 6 7 2
        2 2 1 1 1 1 4 1 5 1 4 1 2 1 1 3 1 1 1 1 2 5 1 1 1 2 2 6 1 1 1 1 9 1
        1 1 2 1 1 2 2 2 5 2 1 1 1 2 2 3 6 2 5 4 1 1 8 1 1 10 2 1 1 1 1 1 2 2
        1 6 1 2 1 1 1 7 6 6 3 3 1 1 5 1 1 1 1 1 2 4 1 1 1 5 2 2 1 1 8 1 2 9 3
        1 1 1 1 2 3 1 1 3 1 1 1 5 1 1 1 1 1 5 1 4 2 1 1 2 3 1 3 1 1 1 1 1 3
        10 1 3 1 2 1 2 1 1 3 3 1 1 1 1 1 9 1 1 2 2 1 1 5 1 1 3 3 2 1 1 1 5 1
        1 4 1 3 1 2 1 4 4 1 1 1 5 1 1 2 2 1 5 1 1 1 1 1 5 6 1 1 2 1 1 1 3 4 1
        1 1 8 1 3 1 9 1 1 2 1 1 1 1 7 1 1 1 1 1 1 5 2 1 4 1 6 1 2 1 1 1 3 1
        4 2 1 1 1 2 5 1 1 1 2 1 1 1 3 1 1 1 1 2 1 4 2 3 2 1 8 4 1 2 1 1 1 1 1
        1 1 1 1 1 3 1 1 2 1 1 1 1 1 2 2 1 1 1 3 1 2 2 4 2 2 1 1 5 1 4 1 1 2
        1 1 1 3 2 1 1 7 1 3 1 2 3 4 1 1 2 1 1 3 1 1 1 1 1 1 1 1 1 1 2 1 2 2 2
        1 2 1 2 1 1 3 1 1 2 1 1 1 1 1 1 6 1 1 5 1 2 1 2 1 1 1 2 1 9 1 1 4 1
        1 1 6 1 1 1 2 2 1 1 1 2 1 9 1 3 1 1 2 1 2 1 1 5 3 1 4 1 1 1 1 1 1 1 1
        2 4 1 1 1 2 1 2 1 1 1 1 1 4 4 2 4 1 1 7 1 2 1 3 8 1 1 1 1 1 1 7 1 4
        1 3 1 1 4 3 2 7 2 1 1 10 1 1 2 4 1 1 2 1 1 1 1 1 1 7 1 2 8 7 2 1 2 7
        3 1 1 2 1 3 1 3 1 1 1 1 3 1 1 1 1 1 3 3 1 9 2 1 2 1 3 1 1 1 3 3 1 2 1
        4 1 2 5 1 4 5 1 2 3 2 3 1 1 1 1 1 1 1 1 2 1 4 4 3 1 1 4 1 3 1 6 3 1
        1 1 1 2 1 2 6 1 3 8 1 1 1 2 1 1 1 1 10 3 3 1 1 1 2 1 1 2 1 1 2 1 1 1
        2 1 3 3 2 1 2 3 1 1 1 1 3 1 2 1 1 4 4 5 1 1 3 2 1 1 7 6 2 1 1 2 7 1 5
        1 1 1 1 1 1 1 4 1 1 1 1 1 8 4 1 1 1 4 1 1 1 2 1 1 1 6 1 10 7 1 2 1 1
        1 2 3 3 1 3 1 4 2 1 2 2 3 1 1 1 2 1 1 2 9 1 9 1 1 1 2 2 2 4 4 1 1 10
        1 1 2 6 1 2 1 1 1 4 1 1 10 1 1 1 2 1 1 2 2 1 1 2 10 2 7 2 3 1 1 1 5
        1 1 1 3 7 2 1 1 1 4 4 4 1 1 5 1 1 1 9 4 1 1 1 9 3 1 1 1 4 3 2 2 7 1 1
        1 3 1 3 8 1 1 3 5 4 1 1 1 1 1 1 1 2 1 1 5 2 1 4 1 1 1 2 2 1 4 1 1 1
        1 1 3 4 10 2 1 1 1 1 2 1 1 1 1 2 1 2 2 1 1 1 1 2 1 2 9 1 1 1 1 1 3 2
        10 1 1 1
    );

    $counter->add($_) for @stream;

    is_deeply(
        [ sort { $a <=> $b } $counter->top ],
        [1 .. 4],
        'stream with non-uniform distribution'
    );
}
