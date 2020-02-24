requires 'perl', '5.010';

requires 'MOP4Import::Base::CLI_JSON', '>= 0.50';

on 'test' => sub {
    requires 'Test::More', '0.98';
};

