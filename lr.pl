#!/usr/bin/perl

use strict;
use warnings;
use utf8;
my $version = 97;
my $versionurl = 'r' . $version . '/';
my $path = '../threejs' . $version . '/src/renderers/shaders/';
my $liburl = $path . 'ShaderLib/'; # also urls at line xxx, xxx and xxx.
my @shaders;

my @mostchunks;
my @httprefs;
my $HTML;
my $includeCount = 0;
my $httpcount = 0;

my $tempurl = 'temp/';
my @tempshaders;

#sub ltrim { my $s = shift; $s =~ s/^\s+//; return $s };
sub rtrim { my $s = shift; $s =~ s/\s+$//; return $s };
#sub  trim { my $s = shift; $s =~ s/^\s+|\s+$//g; return $s };

opendir( DIR, $liburl );
my @files = grep( /\.glsl$/, readdir( DIR ) );
closedir( DIR );

#make a list of shaders from glsl files
foreach my $shader ( @files ) {
	$shader = substr($shader, 0, -10 );
	if ( ! grep( /$shader/, @shaders ) ) {
		push( @shaders, $shader );
	}
}

#create a set of dirty html files in temp folder
if ( -d $tempurl) {
    unlink glob $tempurl . '*.*';
    rmdir $tempurl;
}
mkdir $tempurl; # Check if dir exists. If not create it.
foreach( @shaders ) {
	makeHTML( $_ );
}
makeindex();

#read from temp folder
opendir( DIR, $tempurl );
my @tempfiles = grep( /\.html$/, readdir( DIR ) );
closedir( DIR );

foreach my $tempfile ( @tempfiles ) {
    if ( ! grep( /$tempfile/, @tempshaders ) ) {
        push( @tempshaders, $tempfile );
    }
}

mkdir $versionurl unless -d $versionurl;
#write cleaned html to current folder
foreach( @tempshaders ) {
    cleanHTML( $_ );
}
#stats from line 473, currently counting endifs, not pows!
my @pows;
my @powfiles;
my $totalpows = 0;
for my $i (0 .. $#pows) {
    my $bit = $pows[$i] eq 1 ? ' instance of pow in ' : ' instances of pow in ';
    #print $pows[$i] . $bit . $powfiles[$i] . "\n";
    $totalpows += $pows[$i];
}
#print 'A total of ' . $totalpows . ' occurrences of "endif".';
#print unusedchunks();
sub httplinks { #index list
	my @result;
	foreach my $ref ( @httprefs ) {
		push( @result, '<br>' . $ref . '<br>' );
	}
	return join("", @result );
}

sub unusedchunks { #index list
	my @allchunks;
	my @leftchunks;
	my $chunkurl = $path . 'ShaderChunk/';
	opendir( DIR, $chunkurl );
	my @chunkfiles = grep( /\.glsl$/, readdir( DIR ) );
	closedir( DIR );

	foreach( @chunkfiles ) {
		s/.glsl//;
		push( @allchunks, $_ );  
	}

	foreach my $notdupe ( @allchunks ) {
		if ( ! grep( /$notdupe/, @mostchunks ) ) {
			push( @leftchunks, $notdupe );
		}#print $_."\n";
	}
	return join(", ", @leftchunks );
}

sub cleanHTML {
    my $cleaned = shift;
    #print $cleaned;
    open my $out_fh, '>', $versionurl . $cleaned  or die "Cannot write : $!\n";
     
    my $file = $cleaned;
    my $data = slurp($file);

    $data =~ s/<pre><code class="javascript"><\/code><\/pre>//g;
    $data =~ s/<pre><code class="glsl"><\/code><\/pre>//g;
    $data =~ s/<pre><code class="glsl">.<\/code><\/pre>//smg; # spread over two lines

    print $out_fh $data;

    close $out_fh;

    sub slurp {
        my $file = shift;
        open my $fh, '<', $tempurl . $file or die "Cannot open : $!\n";
        local $/ = undef;
        my $cont = <$fh>;
        close $fh;
        return $cont;
    }
}

sub pretitle {
return qq{<!DOCTYPE html>
<html lang="en">
  <head>
    <title>Lib Reader ( };
}
sub posttitle {
 my $first = qq{ )</title>
	<meta charset="utf-8">
	<link rel="stylesheet" type="text/css" href="../css/tomorrow-night.css">
	<link rel="stylesheet" type="text/css" href="../css/styles.css">
	<script src="../lib/highlight.pack.js"></script>
  </head>
  <body>
	<h3><a href="https://threejs.org">three.js</a> <a href="https://github.com/mrdoob/three.js">R};

    my $last = qq{</a></h3>
	<br>};
    return $first . $version . $last;
} 
sub prefoot {
return qq{<br><a href="https://koober.github.io/Lib-Reader/">Back to Index</a><br>};
}
sub footer {
return '<br><a href="https://github.com/koober/Lib-Reader/">Source</a>
<br><br><script>hljs.initHighlightingOnLoad();</script>
</body></html>';
}
sub intro {
return qq{<br><h1>Lib Reader</h1>
<br><p>Displays the contents of ShaderLib in three.js, including links to contextual references in ShaderChunks.</p>};
}
sub extras {
return qq{<br><p>There are 172 instances of "endif" in ShaderChunks.</p>
<br><p>There are 85 ShaderChunks, of which the following are not currently in use.</p><br>};
}
sub todo {
return qq{<br><h3>To do</h3><div class="indented">
<p> Sample custom shader</p>
<p> Limit frag level navigation to 'mesh' pages?</p>
<p>Indentation not robust in uniforms, could build them as ''chunk'' files first.</p>
<p><del>Surplus code tags, affects styles</del></p></div>
<br>
<br><h3>4 Jul 2018</h3><div class="indented">
<p>To version r97</p>
<p>Add folders per version</p>
<br><h3>4 Jul 2018</h3><div class="indented">
<p>To version r94</p>
<p>Update readme</p></div>
<br><h3>18 Dec 2017</h3><div class="indented">
<p>Make commented links live</p>
<p>Index for index.html</p>
<p>Add nav for frag level</p></div>
<br><h3>17 Dec 2017</h3><div class="indented">
<p>Fix redundant newlines</p></div>
<br><h3>16 Dec 2017</h3><div class="indented">
<p>Fix surplus code tags</p></div>
<br><h3>12 Dec 2017</h3><div class="indented">
<p>Fix points uniforms</p></div>
<br><h3>12 Dec 2017</h3><div class="indented">
<p>Recover missing lights uniforms and add rough indents</p>
<p>Some uniforms formatting</p>
<p>Add links to title</p></div>

<br><h3>11 Dec 2017</h3><div class="indented">

<p>Read from dev branch and push</p></div>

<br>};
}

sub makeindex {
	$includeCount = 0;
	open $HTML, '>', $tempurl . 'index.html' or die 'Failed to open ' . $tempurl . ' index.html' ;

	print $HTML pretitle() . uc( 'index' ) . posttitle() . "\n";

	print $HTML navmenu( '' );
	#==============================
	print $HTML intro() . '<div class="indented">' . httplinks() . '</div>' . extras();
	print $HTML writeChunk( 'encodings_pars_fragment.glsl', '' );
	$includeCount += 1;
	print $HTML writeChunk( 'tonemapping_pars_fragment.glsl', '' );
	print $HTML todo();
	#==============================
	print $HTML footer(); # not prefoot()
	close $HTML or die  'Failed to close index.html';
}

sub makeHTML {
	my $libFile = shift;
	my $prefix = substr( $libFile, 0, 4 );
	$includeCount = 0;
	open $HTML, '>', $tempurl . $libFile . '.html' or die 'Failed to open ' . $tempurl . $libFile . '.html' ;
	
	print $HTML pretitle() . uc( $libFile ) . posttitle() . "\n";

	print $HTML navmenu( '' );

	# ==================== not required for index.html =====================================
	if ( $prefix eq 'mesh' || $prefix eq 'line' ) {

		print $HTML readUniforms( substr( $libFile, 4 ));
	} else {

		print $HTML readUniforms( $libFile );
	}

	print $HTML readLib( $libFile . '_vert' );
	print $HTML navmenu( 'frag' );
	print $HTML readLib( $libFile . '_frag' );
	# ==================== not required for index.html =====================================
	print $HTML prefoot() . footer(); 
	close $HTML or die  'Failed to close' . $libFile . '.html';
}

sub navmenu {
    my $target = shift;
    my @result;
    push( @result, '<ul id="' . $target . '">' . "\n" );
    foreach my $shader ( @shaders ) {
        if( $shader eq 'meshphysical' ) {
            push( @result, '<li><a href="' . $shader . '.html#' . $target . '">meshphysical/standard</a></li>'."\n" );
        } else {
            push( @result, '<li><a href="' . $shader . '.html#' . $target . '">'    . $shader .    '</a></li>'."\n" );
        }
    }
    push( @result, '</ul>' . "\n" );
    return join("", @result );
}

sub inputlabel {
    my $title = shift;
    my $counter = shift;
    my $divindent = shift;
    my $toggle = 'toggle' . $counter;
    my $expand = 'expand' . $counter;
    my $input = "\n" . '<input id="' . $toggle . '" type="checkbox">';
    my $label = '<label for="'.$toggle.'" class="'.$divindent.'">/* '.$title.' */</label>'."\n";
    my $expandiv = '<div id="' . $expand . '" class="' . $divindent . ' expand">';
    return $input . $label . $expandiv;
}

sub readUniforms {
    my $glslFile = shift;
    my $uniFile = $path . 'ShaderLib.js';
    my $count = 0;
    my $physicalCount = 0;
    my @result;
    if($glslFile eq 'physical') {

        $glslFile = 'standard';
    }
    open my $IN, '<', $uniFile or die 'Failed to open' . $uniFile . '.html';
    push( @result, "\n" . "\n" . '<h2>' . $glslFile . '.uniforms</h2>' . "\n" . "\n" );
    
    my $match = $glslFile . ':';

    while ( my $line = <$IN> ) {
        $line =~ s/^\s+//;
        my $lineStart = 0;
        
        if( $line =~ $match ) {
            $count = 1;
        } elsif( $line =~ 'vertexShader:' ) {
            $count = 0;
        } elsif( $count ) {

            if( $line =~ 'uniforms:' ) {
                push( @result, "<pre><code class='javascript'>" );
                if( $match eq 'cube:' || $match eq 'equirect:' ) {
                    push( @result, 'uniforms: {' . "\n" );
                    next;
                } else {
                    push( @result, 'uniforms: UniformsUtils.merge( [' . "\n" );
                    next;
                }

            } elsif( substr($line, 0, 1) =~ '}' ) {

                if( $match eq 'cube:' || $match eq 'equirect:' ) {
                    push( @result, '}' . "\n" );
                } else {
                    push( @result, "\t" . '}' . "\n" );
                }

            } elsif( substr($line, 0, 1) =~ '{' ) {

                if( $match eq 'cube:' || $match eq 'equirect:' ) {
                    push( @result, '{' . "\n" );
                } else {
                    push( @result, "\t" . '{' . "\n" );
                }
            
            } elsif( substr($line, 0, 1) =~ ']' ) {

                if ($glslFile ne 'standard') {
                    push( @result, $line );
                }
                
            } elsif( $line =~ 'UniformsLib' ) {

                push( @result, '</code></pre>'. "\n" );
                $line =~ s/,$//; # trailing comma

                push( @result, writeUniform( $line ) );
                
                push( @result, '<pre><code class="javascript">' );

            } elsif( $match eq 'cube:' || $match eq 'equirect:' ) {
                    push( @result,  "\t" .  $line );
            } else {
                push( @result,  "\t" . "\t" . $line );
            }
            $includeCount += 1;
        }

        if( $glslFile eq 'standard') {
            if( $line =~ 'ShaderLib.standard.uniforms,' ) {
                $physicalCount = 1;
            } elsif( $line =~ 'vertexShader:' ) {
                $physicalCount = 0;
            } elsif( $physicalCount ) {
                
                $lineStart = substr( $line, 0, 1 );
                if (  $lineStart =~ '{' ) {
                    push( @result, "\n" . "\t" . '{ // for physical uniforms, add these to standard uniforms' . "\n" ); 
                } elsif (  $lineStart =~ ']'  ) {
                    push( @result,  $line ); 
                } elsif (  $lineStart =~ '}'  ) {
                    push( @result, "\t" . $line ); 
                } else {
                    push( @result, "\t" . "\t" . $line );
                }
            }
        }
    }
    push( @result, '</code></pre>'. "\n" );
    return join("", @result );
}

sub writeUniform {
    
    my $uniform = shift;
    my $term = substr( $uniform, rindex( $uniform, '.' ) + 1 );
    my $match = rtrim($term) . ':';
    my $count = 0;
    my $lcount = 0;
    my $prop = 'properties';
    my $pcount = 0;
    my @result;

    open my $IN, '<', $path . 'UniformsLib.js' or die 'Failed to open' . $path . 'UniformsLib.js';

    push( @result, inputlabel( $uniform, $includeCount, 'indented' ) );

    push( @result, '<pre><code class="javascript">' );

    while ( my $line = <$IN> ) {
        $line =~ s/^\s+//;
        
        if( $line =~ $match  ) {
            push( @result, '{' . "\n" );
            $count = 1;
        } elsif( substr( $line, 0, 1 ) =~ '}' && $match eq 'sprite:' ) {
            $count = 0;# HACK: 'sprite' is last in uniformsLib after r94, previously 'points'
        } elsif( substr( $line, 0, 2 ) =~ '},'  ) {
            $count = 0;

        } elsif( $count ) {
            if( $line =~ $prop && $match eq 'lights:') {
                $pcount = 1;
                push( @result, "\t" . $line );
            } elsif(  substr( $line, 0, 3 ) =~ '} }' && $match eq 'lights:' ) {
                $pcount = 0;
                #print $HTML "\t" . $line;
            }
            next if $line =~ /^$/;
            if( $pcount ) {
                if($line =~ $prop){
                    next;
                } else {
                    push( @result, "\t" . "\t" . $line );
                }
            } else {
                push( @result, "\t" . $line );
            }
        }
    }
    push( @result, '} </code></pre></div>' . "\n" ); # end expanding div
    return join("", @result );
}

sub readLib {
    my $glslFile = shift . '.glsl';
    my @result;
    open my $IN, '<', $liburl . $glslFile  or die 'Failed to open' . $liburl . $glslFile ;

    push( @result, "\n". "\n" . '<h2>' . $glslFile . '</h2>'. "\n". "\n" );

    push( @result, perVoid( $IN, '' ) );
    push( @result, perVoid( $IN, 'indented' ) );
    return join("", @result );
}

sub perVoid { 
    my $IN = shift;
    my $indent = shift;
    my @result;
    push( @result, '<pre><code class="glsl">' ); 
    while ( my $line = <$IN> ) {

        if( $line =~ '#include' ) {
            push( @result, '</code></pre>' . "\n" );
            my ( $chunk )= $line =~ /<(.*)>/;

            if ( ! grep( /$chunk/, @mostchunks ) ) {
                push( @mostchunks, $chunk );
            }
            push( @result, writeChunk( $chunk . '.glsl', $indent ) );

            push( @result, '<pre><code class="glsl">' ); # next line might be code
            $includeCount += 1;
        } else {
            push( @result, $line );
        }
        last if $line =~ 'void';
    }
    push( @result, '</code></pre>'. "\n" );
    return join("", @result );
}

sub writeChunk {
    my $chunkfile = shift;
    my $indent = shift;
    my $url = $path . 'ShaderChunk/';
    my @result;
    my $powcount;

    open my $INB, '<', $url . $chunkfile or die 'Failed to open' . $chunkfile;

    push( @result, inputlabel( $chunkfile, $includeCount, $indent ) );
    push( @result, '<pre><code class="glsl">' . "\n" );
    while ( my $line = <$INB> ) {
        if( index( $line, ' http' ) != -1 ) {

            chomp $line;
            my $find =  substr( $line, rindex( $line, 'http'));
            my $replace = '<a href="' . $find . '">' . $find . '</a>' . "\n" . "\n";
            $line =~  s/$find/$replace/;
            push( @result, $line );
            $httpcount += 1;
            if ( ! grep( /$replace/, @httprefs ) ) {
                push( @httprefs, $replace );
            }
        } else {
            $powcount += () = $line =~ /endif/g; #counting occurrences of...
            push( @result, $line );
        }
    }

    if ($powcount > 0) {
        if ( ! grep( /$chunkfile/, @powfiles ) ) {
            push( @pows, $powcount );
            push( @powfiles, $chunkfile );
        }
    }
    push( @result, '</code></pre></div>' . "\n" );
    return join("", @result );
}
