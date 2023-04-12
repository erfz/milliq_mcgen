{

  // const char * r2file = "run2/c-to-mu.root";
  // const char * r3file = "run3/c-to-mu.root";
  // const char * pdfFile = "c-to-mu_Run2_Run3_comparison.pdf";
  // const char * title   = "c-to-mu";

  // const char * r2file = "run2/b-to-mu.root";
  // const char * r3file = "run3/b-to-mu.root";
  // const char * pdfFile = "b-to-mu_Run2_Run3_comparison.pdf";
  // const char * title   = "b-to-mu";

  const char * r2file = "run2/b-to-c-to-mu.root";
  const char * r3file = "run3/b-to-c-to-mu.root";
  const char * pdfFile = "b-to-c-to-mu_Run2_Run3_comparison.pdf";
  const char * title   = "b-to-c-to-mu";

  // Load Wouter's nice utility
  gROOT->ProcessLine(".L ../../oniaDirect/upsilon/histio.cc");

  // Load the the files with r2/r3 prefix
  loadHist(r2file,"r2");
  loadHist(r3file,"r3");
  
  gStyle->SetOptStat(0);
  // gStyle->SetOptTitle(0);


  // A canvas with a grid
  TCanvas* c1 = new TCanvas();
  c1->SetGrid();

  // Take ratios to the run 2 central value
  TH1D* cenRatio = new TH1D(*r2_central);
  cenRatio->Divide(r2_central);
  TH1D* upRatio = new TH1D(*r2_up);
  upRatio->Divide(r2_central);
  TH1D* downRatio = new TH1D(*r2_down);
  downRatio->Divide(r2_central);

  
  TH1D* new_cenRatio = new TH1D(*r3_central);
  new_cenRatio->Divide(r2_central);
  TH1D* new_upRatio = new TH1D(*r3_up);
  new_upRatio->Divide(r2_central);
  TH1D* new_downRatio = new TH1D(*r3_down);
  new_downRatio->Divide(r2_central);

  // Set colors, style, titles, naximum
  cenRatio->SetLineColor(kBlue);
  upRatio->SetLineColor(kBlue);
  downRatio->SetLineColor(kBlue);
  new_cenRatio->SetLineColor(kRed);
  new_upRatio->SetLineColor(kRed);
  new_downRatio->SetLineColor(kRed);
  
  upRatio->SetLineStyle(10);
  downRatio->SetLineStyle(10);
  new_upRatio->SetLineStyle(10);
  new_downRatio->SetLineStyle(10);

  upRatio->SetMaximum(2.);
  upRatio->SetMinimum(0.);
  upRatio->GetXaxis()->SetTitle("Pt (GeV/c)");
  upRatio->SetTitle(title);


    // More stuff
    upRatio->GetXaxis()->SetLabelSize(0.05);
    upRatio->GetYaxis()->SetLabelSize(0.05);
    // upRatio->SetTitleSize(2);
    // c1->SetBottomMargin(0.2);
    int lw = 3;
    cenRatio->SetLineWidth(lw);
    upRatio->SetLineWidth(lw);
    downRatio->SetLineWidth(lw);
    new_cenRatio->SetLineWidth(lw);
    new_upRatio->SetLineWidth(lw);
    new_downRatio->SetLineWidth(lw);

    upRatio->GetYaxis()->SetTitle(" ");


  
  // Plot them 
  upRatio->Draw("HIST");
  downRatio->Draw("HISTSAME");
  cenRatio->Draw("HISTSAME");
  new_upRatio->Draw("HISTSAME");
  new_downRatio->Draw("HISTSAME");
  new_cenRatio->Draw("HISTSAME");

  // save to pdf
  c1->SaveAs(pdfFile);
  
}
