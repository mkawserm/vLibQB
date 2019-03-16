import os, sys, subprocess, shutil, argparse, re
import jinja2
from jinja2 import BaseLoader

ROOT_PATH = '##'
#os.chdir(ROOT_PATH)

latex_jinja_env = jinja2.Environment(
     block_start_string = '\BLOCK{',
     block_end_string = '}',
     variable_start_string = '\VAR{',
     variable_end_string = '}',
     comment_start_string = '\#{',
     comment_end_string = '}',
     line_statement_prefix = '%-',
     line_comment_prefix = '%#',
     trim_blocks = True,
     autoescape = False,
     loader = BaseLoader
)


TEMPLATE_STR = """
\\documentclass[border={1mm 1mm 1mm 1mm}]{standalone}

\\usepackage{color}
\\usepackage{graphicx}
\\usepackage[utf8]{inputenc}
\\usepackage{amsmath}

\\begin{document}

    \\input{\\VAR{inputfile}}

\\end{document}
"""

template = latex_jinja_env.from_string(TEMPLATE_STR)




#main configuration
#------------------
#output specification
output_suffix = "_cv"
create_emf_file = '##'
create_eps_file = '##'
create_svg_file = '##'
create_png_file = '##'
create_pdf_file = '##'
create_pdf2_file = '##'

folder_install = '##'

output_width = '##'
output_height = '##'

AllFiles = '##'
pure_or_text_or_clean = '##'
###############################################################################

os.chdir(folder_install)

###############################################################################
# Parsing options
# arg_parser = argparse.ArgumentParser(description="Enjoy the cool scons building tool!")
# arg_parser.add_argument('-c', '--clean', action='store_true', dest='clean', default=False, help='clean unversioned documents')
# arg_parser.add_argument('-s', '--silent', action='store_true', dest='silent', default=False, help='Puts latex into silent mode. No output will be shown and no errors as well. Only a list at the end which file was not successful.')

# arg_parser.add_argument('-p', '--pure', action='store_true', dest='pure', default=False, help='Builds only the pure svgs')
# arg_parser.add_argument('-t', '--tex', action='store_true', dest='tex', default=False, help='Build only the tex svgs')

# arguments = arg_parser.parse_args()



###############################################################################
# Handle pure svgs
###############################################################################
if pure_or_text_or_clean == 1:
    #filter .svg files and avoid double-conversion
    InputFiles = []
    for File in AllFiles:
        print(File)
        Extension = os.path.splitext(os.path.basename(File))[1]
        if (Extension.lower() == ".svg") and File.find(output_suffix) == -1:
            InputFiles.append(File)

    for InputFile in InputFiles:
        #extract base file name (without path and extension) and extension
        BaseFileName = os.path.splitext(os.path.basename(InputFile))[0]
        Extension = os.path.splitext(os.path.basename(InputFile))[1]

        #set output filenames
        OutputFileNames = folder_install +"/"+ BaseFileName + output_suffix

        #define output file names
        LatexFile_wo_ext = OutputFileNames
        PDFFile = OutputFileNames + ".pdf"
        SVGFile = OutputFileNames + ".svg"
        PNGFile = OutputFileNames + ".png"
        EMFFile = OutputFileNames + ".emf"
        EPSFile = OutputFileNames + ".eps"

        if Extension.lower() == ".svg":
            print ("Converting " + BaseFileName + Extension + " (SVG-file)...")

            try:
                if create_png_file == True:
                  cmd = "inkscape"+" --file=\"" + InputFile+"\" --export-png=\"" + PNGFile + "\" --export-width=" + str(output_width)# + ' --export-height=' + str(output_height)
                  print('Compile:' + cmd)
                  sys_out = os.system(cmd)

                if create_emf_file == True:
                  cmd = "inkscape"+" --file=\"" + InputFile+"\" --export-emf=\"" + EMFFile+"\""
                  print('Compile:' + cmd)
                  sys_out = os.system(cmd)

                if create_eps_file == True:
                  cmd = "inkscape"+" --file=\"" + InputFile+"\" --export-eps=\"" + EPSFile+"\""
                  print('Compile:' + cmd)
                  sys_out = os.system(cmd)

                if create_pdf_file == True:
                  cmd = "inkscape"+" --file=\"" + InputFile+"\" --export-pdf=\"" + PDFFile +"\""
                  print('Compile:' + cmd)
                  sys_out = os.system(cmd)

                if create_pdf2_file == True:
                  cmd = "gs"+" -o \"" + PDFFile+"\" -dNoOutputFonts -sDEVICE=pdfwrite -dQUIET \""+PDFFile+"\""
                  sys_out = os.system(cmd)

            except subprocess.CalledProcessError as grepexc:
              print("error code", grepexc.returncode, grepexc.output)
              #sys.exit(10)

            print("Conversion pure svgs Done!")

        #unknown file type
        else:
            print("Unknown filetype of " + BaseFileName + Extension + " (has to be .svg) -> ignoring this file")

###############################################################################
# Handle tex_svgs
###############################################################################

if pure_or_text_or_clean == 2:
    #filter .svg files and avoid double-conversion
    InputFiles = []
    for File in AllFiles:
        print(File)
        Extension = os.path.splitext(os.path.basename(File))[1]
        if (Extension.lower() == ".svg") and File.find(output_suffix) == -1:
            InputFiles.append(File)

    for InputFile in InputFiles:
        #extract base file name (without path and extension) and extension
        BaseFileName = os.path.splitext(os.path.basename(InputFile))[0]
        Extension = os.path.splitext(os.path.basename(InputFile))[1]

        #set output filenames
        OutputFileNames = folder_install +"/"+ BaseFileName + output_suffix

        PDFtexFile = folder_install+'/' + BaseFileName + '_tex.pdf'
        LatexFile = folder_install+'/' + BaseFileName + '.tex'
        LatexFile_wo_ext = folder_install+'/' + BaseFileName
        PDFFilePaths = folder_install+'/' + BaseFileName + '_prebuilt.pdf'
        #define output file names

        PDFFile = OutputFileNames + ".pdf"
        SVGFile = OutputFileNames + ".svg"
        PNGFile = OutputFileNames + ".png"
        EMFFile = OutputFileNames + ".emf"
        EPSFile = OutputFileNames + ".eps"

        if Extension.lower() == ".svg":
            print ("Converting " + BaseFileName + Extension + " (SVG-file)...")

            try:
              cmd = "inkscape"+" --file=\"" + InputFile + "\" --export-pdf=\"" + PDFtexFile + "\" --export-latex"
              print('Compile:' + cmd)
              sys_out = os.system(cmd)


              with open(LatexFile,'w+') as f:
                f.write(template.render(inputfile=PDFtexFile+'_tex'))

              cmd="pdflatex" + " -interaction=batchmode \"" + LatexFile + "\" -output-directory=\""  + folder_install +"\""
              print('LaTeX-Compile:' + cmd)
              sys_out = os.system(cmd)

              cmd="gs"+" -o \"" + PDFFilePaths+"\" -dNoOutputFonts"+" -sDEVICE=pdfwrite"+" -dQUIET \"" + LatexFile_wo_ext+".pdf\""
              print('Ghostscript:' + cmd)
              sys_out = os.system(cmd)

              if create_svg_file == True:
                cmd = "inkscape"+" --file=\"" + PDFFilePaths + "\" --export-plain-svg=\"" + SVGFile+"\""
                print('Compile:' + cmd)
                sys_out = os.system(out)

              if create_png_file == True:
                cmd = "inkscape"+" --file=\"" + PDFFilePaths +"\" --export-png=\"" + PNGFile + "\" --export-width=" + str(output_width) # + ' --export-height=' + str(output_height)
                print('Compile:' + cmd)
                sys_out = os.system(cmd)

              if create_emf_file == True:
                cmd = "inkscape"+" --file=\"" + PDFFilePaths +"\" --export-emf=\"" + EMFFile+"\""
                print('Compile:' + cmd)
                sys_out = os.system(cmd)

              if create_eps_file == True:
                cmd = "inkscape"+" --file=\"" + PDFFilePaths +"\" --export-eps=\"" + EPSFile+"\""
                print('Compile:' + cmd)
                sys_out = os.system(cmd)


            except subprocess.CalledProcessError as grepexc:
              print("error code", grepexc.returncode, grepexc.output)
              sys.exit(10)

            print("Conversion tex svgs Done!")

        	#remove helper files
            try:
              os.remove(PDFtexFile+'_tex')
              os.remove(PDFFilePaths)
              os.remove(LatexFile)
              os.remove(PDFtexFile)
              os.remove(LatexFile_wo_ext + ".aux")
              os.remove(LatexFile_wo_ext + ".log")
            except Exception as e:
              pass
              #print(e)

        #unknown file type
        else:
            print("Unknown filetype of " + BaseFileName + Extension + " (has to be .svg) -> ignoring this file")

###############################################################################
# clean up
###############################################################################
if pure_or_text_or_clean == 3:
    for root, dirs, files in os.walk(folder_install):
        for file in files:
            if file.endswith(".aux"):
                os.remove(os.path.join(file))
            if file.endswith(".log"):
                os.remove(os.path.join(file))

    print('Aufräumen erfolgreich ;-)')
