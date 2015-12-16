#-*-Perl-*-

use strict;
use ExtUtils::MakeMaker;
use File::Temp qw(tempfile);
use FindBin '$Bin';
use constant TEST_COUNT => 6;

use lib "$Bin/../lib", "$Bin/../blib/lib", "$Bin/../blib/arch";

BEGIN {
    # to handle systems with no installed Test module
    # we include the t dir (where a copy of Test.pm is located)
    # as a fallback
    eval { require Test; };
    if ($@) {
        use lib 't';
    }
    use Test;
    plan test => TEST_COUNT;
}

use Bio::DB::HTS;
use Bio::DB::HTS::AlignWrapper;


{
    my $hts = Bio::DB::HTS->new(-bam=>"$Bin/data/ex1.sam");
    ok($hts);

    my $hts_file = $hts->hts_file;
    my $header = $hts_file->header_read();
    ok($header);

    printf("Reading\n") ;
    my $align = $hts_file->read1($header);
    ok($align->qseq,'CACTAGTGGCTCATTGTAAATGTGTGGTTTAACTCG');
    ok($align->start,1);

    $align = $hts_file->read1($header);
    ok($align->start,3);
    ok($header->target_name->[$align->tid],'seq1');

}

exit 0;

__END__
