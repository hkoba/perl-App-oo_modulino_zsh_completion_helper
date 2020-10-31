requires 'perl', '5.010';

requires 'MOP4Import::Declare', '>= 0.050';

on 'test' => sub {
    requires 'Test::More', '0.98';
};

