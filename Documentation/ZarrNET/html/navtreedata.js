/*
 @licstart  The following is the entire license notice for the JavaScript code in this file.

 The MIT License (MIT)

 Copyright (C) 1997-2020 by Dimitri van Heesch

 Permission is hereby granted, free of charge, to any person obtaining a copy of this software
 and associated documentation files (the "Software"), to deal in the Software without restriction,
 including without limitation the rights to use, copy, modify, merge, publish, distribute,
 sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:

 The above copyright notice and this permission notice shall be included in all copies or
 substantial portions of the Software.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING
 BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
 DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

 @licend  The above is the entire license notice for the JavaScript code in this file
*/
var NAVTREE =
[
  [ "Zarr.NET", "index.html", [
    [ "Features", "index.html#autotoc_md22", null ],
    [ "Installation", "index.html#autotoc_md23", [
      [ "Dependencies", "index.html#autotoc_md24", null ]
    ] ],
    [ "Documentation", "index.html#autotoc_md25", null ],
    [ "Quick Start", "index.html#autotoc_md26", [
      [ "Read a single 2D plane from a multiscale image", "index.html#autotoc_md27", null ],
      [ "Read using physical coordinates (ROI in microns)", "index.html#autotoc_md28", null ],
      [ "Read from remote HTTP/S3 URLs", "index.html#autotoc_md29", null ],
      [ "Custom HTTP configuration (auth, timeouts)", "index.html#autotoc_md30", null ],
      [ "Navigate HCS Plate structure", "index.html#autotoc_md31", null ],
      [ "Work with labels (segmentation masks)", "index.html#autotoc_md32", null ]
    ] ],
    [ "Architecture", "index.html#autotoc_md33", [
      [ "Design Principles", "index.html#autotoc_md34", null ]
    ] ],
    [ "Supported Features", "index.html#autotoc_md35", [
      [ "Data Types", "index.html#autotoc_md36", null ],
      [ "Compression", "index.html#autotoc_md37", null ],
      [ "OME-Zarr Node Types", "index.html#autotoc_md38", null ],
      [ "Zarr Versions", "index.html#autotoc_md39", null ],
      [ "OME-Zarr 0.6 transformations", "index.html#autotoc_md40", null ]
    ] ],
    [ "API Overview", "index.html#autotoc_md41", [
      [ "Core Classes", "index.html#autotoc_md42", [
        [ "OmeZarrReader", "index.html#autotoc_md43", null ],
        [ "ResolutionLevelNode", "index.html#autotoc_md44", null ],
        [ "Low-level chunk API", "index.html#autotoc_md45", null ],
        [ "PlaneResult", "index.html#autotoc_md46", null ],
        [ "PhysicalROI and PixelRegion", "index.html#autotoc_md47", null ]
      ] ]
    ] ],
    [ "Examples", "index.html#autotoc_md48", [
      [ "Iterate through a Z-stack", "index.html#autotoc_md49", null ],
      [ "Read all channels as separate planes", "index.html#autotoc_md50", null ],
      [ "Choose optimal resolution level for display", "index.html#autotoc_md51", null ],
      [ "Process an entire HCS plate", "index.html#autotoc_md52", null ],
      [ "Save plane as image file (using ImageSharp)", "index.html#autotoc_md53", null ]
    ] ],
    [ "Performance Considerations", "index.html#autotoc_md54", [
      [ "Chunk-Aligned Reads", "index.html#autotoc_md55", null ],
      [ "Resolution Level Selection", "index.html#autotoc_md56", null ],
      [ "Memory Management", "index.html#autotoc_md57", null ]
    ] ],
    [ "Limitations", "index.html#autotoc_md58", null ],
    [ "Roadmap", "index.html#autotoc_md59", null ],
    [ "Contributing", "index.html#autotoc_md60", [
      [ "Converting a Zarr v2 array to v3", "index.html#autotoc_md61", null ]
    ] ],
    [ "License", "index.html#autotoc_md62", null ],
    [ "Acknowledgments", "index.html#autotoc_md63", null ],
    [ "Support", "index.html#autotoc_md64", null ],
    [ "Please use image.sc forum for discussion.", "index.html#autotoc_md65", null ],
    [ "HTTP/Remote Storage Support - Implementation Summary", "md__zarr_n_e_t_2_h_t_t_p___s_u_p_p_o_r_t.html", [
      [ "What Was Added", "md__zarr_n_e_t_2_h_t_t_p___s_u_p_p_o_r_t.html#autotoc_md1", [
        [ "New Files", "md__zarr_n_e_t_2_h_t_t_p___s_u_p_p_o_r_t.html#autotoc_md2", null ],
        [ "Modified Files", "md__zarr_n_e_t_2_h_t_t_p___s_u_p_p_o_r_t.html#autotoc_md3", null ],
        [ "Usage", "md__zarr_n_e_t_2_h_t_t_p___s_u_p_p_o_r_t.html#autotoc_md4", null ]
      ] ],
      [ "Supported Remote Storage", "md__zarr_n_e_t_2_h_t_t_p___s_u_p_p_o_r_t.html#autotoc_md5", null ],
      [ "How It Works", "md__zarr_n_e_t_2_h_t_t_p___s_u_p_p_o_r_t.html#autotoc_md6", [
        [ "Store Detection", "md__zarr_n_e_t_2_h_t_t_p___s_u_p_p_o_r_t.html#autotoc_md7", null ],
        [ "HTTP Requests", "md__zarr_n_e_t_2_h_t_t_p___s_u_p_p_o_r_t.html#autotoc_md8", null ],
        [ "Metadata Caching", "md__zarr_n_e_t_2_h_t_t_p___s_u_p_p_o_r_t.html#autotoc_md9", null ],
        [ "Performance Considerations", "md__zarr_n_e_t_2_h_t_t_p___s_u_p_p_o_r_t.html#autotoc_md10", null ]
      ] ],
      [ "Examples Provided", "md__zarr_n_e_t_2_h_t_t_p___s_u_p_p_o_r_t.html#autotoc_md11", null ],
      [ "Testing", "md__zarr_n_e_t_2_h_t_t_p___s_u_p_p_o_r_t.html#autotoc_md12", null ],
      [ "Limitations", "md__zarr_n_e_t_2_h_t_t_p___s_u_p_p_o_r_t.html#autotoc_md13", null ],
      [ "Future Enhancements", "md__zarr_n_e_t_2_h_t_t_p___s_u_p_p_o_r_t.html#autotoc_md14", [
        [ "Planned", "md__zarr_n_e_t_2_h_t_t_p___s_u_p_p_o_r_t.html#autotoc_md15", null ],
        [ "Possible", "md__zarr_n_e_t_2_h_t_t_p___s_u_p_p_o_r_t.html#autotoc_md16", null ]
      ] ],
      [ "Architecture Notes", "md__zarr_n_e_t_2_h_t_t_p___s_u_p_p_o_r_t.html#autotoc_md17", null ],
      [ "Dependencies", "md__zarr_n_e_t_2_h_t_t_p___s_u_p_p_o_r_t.html#autotoc_md18", null ],
      [ "Breaking Changes", "md__zarr_n_e_t_2_h_t_t_p___s_u_p_p_o_r_t.html#autotoc_md19", null ]
    ] ],
    [ "ZarrNET 0.8.0", "md__zarr_n_e_t_2_r_e_l_e_a_s_e___n_o_t_e_s.html", [
      [ "Added", "md__zarr_n_e_t_2_r_e_l_e_a_s_e___n_o_t_e_s.html#autotoc_md67", null ],
      [ "Changed", "md__zarr_n_e_t_2_r_e_l_e_a_s_e___n_o_t_e_s.html#autotoc_md68", null ],
      [ "Tests and documentation", "md__zarr_n_e_t_2_r_e_l_e_a_s_e___n_o_t_e_s.html#autotoc_md69", null ],
      [ "Current limits", "md__zarr_n_e_t_2_r_e_l_e_a_s_e___n_o_t_e_s.html#autotoc_md70", null ]
    ] ],
    [ "Zarr v2 Support Added", "md__zarr_n_e_t_2_v2___s_u_p_p_o_r_t.html", [
      [ "What Changed", "md__zarr_n_e_t_2_v2___s_u_p_p_o_r_t.html#autotoc_md72", [
        [ "v2 File Structure", "md__zarr_n_e_t_2_v2___s_u_p_p_o_r_t.html#autotoc_md73", null ],
        [ "v3 File Structure (for reference)", "md__zarr_n_e_t_2_v2___s_u_p_p_o_r_t.html#autotoc_md74", null ]
      ] ],
      [ "Files Modified", "md__zarr_n_e_t_2_v2___s_u_p_p_o_r_t.html#autotoc_md75", null ],
      [ "Usage (no changes needed)", "md__zarr_n_e_t_2_v2___s_u_p_p_o_r_t.html#autotoc_md76", null ],
      [ "v2 Specifics Worth Knowing", "md__zarr_n_e_t_2_v2___s_u_p_p_o_r_t.html#autotoc_md77", null ],
      [ "Testing Your Fiji Data", "md__zarr_n_e_t_2_v2___s_u_p_p_o_r_t.html#autotoc_md78", null ]
    ] ],
    [ "Packages", "namespaces.html", [
      [ "Package List", "namespaces.html", "namespaces_dup" ],
      [ "Package Members", "namespacemembers.html", [
        [ "All", "namespacemembers.html", null ],
        [ "Functions", "namespacemembers_func.html", null ],
        [ "Enumerations", "namespacemembers_enum.html", null ]
      ] ]
    ] ],
    [ "Classes", "annotated.html", [
      [ "Class List", "annotated.html", "annotated_dup" ],
      [ "Class Index", "classes.html", null ],
      [ "Class Hierarchy", "hierarchy.html", "hierarchy" ],
      [ "Class Members", "functions.html", [
        [ "All", "functions.html", null ],
        [ "Functions", "functions_func.html", null ],
        [ "Variables", "functions_vars.html", null ],
        [ "Properties", "functions_prop.html", null ]
      ] ]
    ] ]
  ] ]
];

var NAVTREEINDEX =
[
"annotated.html",
"class_zarr_n_e_t_1_1_core_1_1_zarr_1_1_store_1_1_chunk_lru_cache.html",
"index.html#autotoc_md64"
];

var SYNCONMSG = 'click to disable panel synchronisation';
var SYNCOFFMSG = 'click to enable panel synchronisation';