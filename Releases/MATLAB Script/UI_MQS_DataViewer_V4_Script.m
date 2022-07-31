classdef UI_MQS_DataViewer_V4_Script < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIWaveBasinDataViewerUIFigure   matlab.ui.Figure
        VelocitiesLabel                 matlab.ui.control.Label
        GroundContactListBox            matlab.ui.control.ListBox
        GroundContactLabel              matlab.ui.control.Label
        VelocityBodyFixedListBox        matlab.ui.control.ListBox
        VelocityBodyFixedLabel          matlab.ui.control.Label
        PlotCustomXvsYButton            matlab.ui.control.Button
        OpenTrialClusterGroupButton     matlab.ui.control.Button
        CloseAllFiguresButton           matlab.ui.control.Button
        FFTButton                       matlab.ui.control.Button
        PlotEnsembleAverageButton       matlab.ui.control.Button
        FilesCurrentlyOpenListBox       matlab.ui.control.ListBox
        FilesCurrentlyOpenListBoxLabel  matlab.ui.control.Label
        UITable                         matlab.ui.control.Table
        Image_4                         matlab.ui.control.Image
        Image_3                         matlab.ui.control.Image
        SecondsprereleaseSpinner        matlab.ui.control.Spinner
        ModelMassPropertiesButton       matlab.ui.control.Button
        RunParametersMetadataTextAreaLabel_2  matlab.ui.control.Label
        SubtrialwindowsettingsLabel     matlab.ui.control.Label
        SecondspostreleaseSpinner       matlab.ui.control.Spinner
        SecondspostreleaseSpinnerLabel  matlab.ui.control.Label
        SecondsprereleaseSpinnerLabel   matlab.ui.control.Label
        ApproximatesurfacecontourCheckBox  matlab.ui.control.CheckBox
        DeltaFluidFieldCheckBox_2       matlab.ui.control.CheckBox
        AcousticGaugesCheckBox          matlab.ui.control.CheckBox
        DeltaFluidFieldCheckBox         matlab.ui.control.CheckBox
        ListofSignalsButton             matlab.ui.control.Button
        Image_2                         matlab.ui.control.Image
        Image                           matlab.ui.control.Image
        ROSCommandsListBox              matlab.ui.control.ListBox
        ROSCommandsListBoxLabel         matlab.ui.control.Label
        WaveSensorLocationsButton       matlab.ui.control.Button
        FusedBreakerMeasurementsListBox  matlab.ui.control.ListBox
        FusedBreakerMeasurementsLabel   matlab.ui.control.Label
        PlayVideosButton                matlab.ui.control.Button
        CSVExportButton                 matlab.ui.control.Button
        WaveMeasurementsLabel           matlab.ui.control.Label
        IMUDataLabel                    matlab.ui.control.Label
        GapFilledKalmanFilteredMoCapDataLabel  matlab.ui.control.Label
        RawMoCapDataLabel               matlab.ui.control.Label
        MQSInputsLabel                  matlab.ui.control.Label
        RAWBreakerMeasurementsListBox   matlab.ui.control.ListBox
        RAWBreakerMeasurementsLabel     matlab.ui.control.Label
        DeepWaterAcousticsListBox       matlab.ui.control.ListBox
        DeepWaterAcousticsLabel         matlab.ui.control.Label
        AngularRatesListBox             matlab.ui.control.ListBox
        AngularRatesListBoxLabel        matlab.ui.control.Label
        AccelerationsListBox            matlab.ui.control.ListBox
        AccelerationsListBoxLabel       matlab.ui.control.Label
        OrientationGapFilledListBox     matlab.ui.control.ListBox
        OrientationGapFilledListBoxLabel  matlab.ui.control.Label
        PositionXYZGapFilledListBox     matlab.ui.control.ListBox
        PositionXYZGapFilledListBoxLabel  matlab.ui.control.Label
        OrientationListBox              matlab.ui.control.ListBox
        OrientationListBoxLabel         matlab.ui.control.Label
        LoadandReviewTrialsLabel        matlab.ui.control.Label
        SelectSubTrialsListBox          matlab.ui.control.ListBox
        SelectSubTrialsListBoxLabel     matlab.ui.control.Label
        PlottingStyleButtonGroup        matlab.ui.container.ButtonGroup
        SubTrialsOverlaidT0atstartofeachsubtrialButton  matlab.ui.control.RadioButton
        SubTrialsSequentialT0atstartofrunButton  matlab.ui.control.RadioButton
        PlotSelectionButton             matlab.ui.control.Button
        VelocityGapFilledListBox        matlab.ui.control.ListBox
        VelocityGapFilledListBoxLabel   matlab.ui.control.Label
        PositionXYZListBox              matlab.ui.control.ListBox
        PositionXYZLabel                matlab.ui.control.Label
        LoggedActuationListBox          matlab.ui.control.ListBox
        LoggedActuationLabel            matlab.ui.control.Label
        PlotCustomizationLabel          matlab.ui.control.Label
        RunParametersMetadataTextAreaLabel  matlab.ui.control.Label
        OpenSingleTrialButton           matlab.ui.control.Button
    end


    properties (Access = public)

        TrialData=0; % Description
        TrialDataMult=0;
        CollMesh=[];
        FilePath=0;
        FileLoadedName=0;
        VidListTemp={0};
        PreTime=10;
        PostTime=40;
        Vidfig=[];
        SigListFig=[];
        MassTable=[];
        MassPropFig=[];
        MultiRuns=0;
        FFTfig=[];
        Timefig=[];
        Ensemblefig=[];
        GroupLoaded=0;
        GroupPath=[];
        GroupSet=[];
        AnimationWindow=[]; % Description
        MovieDataBaseMQS=load("MovieDatabase.mat"); % Description
    end

    properties (Access = private)
        oldpath=addpath(['./imgs']); % Add path for icons and images if running as a script (working directory must contain the script)
    end



    methods (Access = private)

        function Tempfig = PlotTS(app,Tempfig,TSob,N_plots,count,RepstoInclude,PlotStyle,ReusePlot,N_T)
            Trial_TSMult=app.TrialDataMult;
            Trial_TS=Trial_TSMult(N_T);
            if ~ReusePlot
                Tempfig.axes(count)=subplot(N_plots,1,count);
            else
                axes(Tempfig.axes(count));
                hold on
            end
            switch PlotStyle
                case 'Overlay'
                    Zerotimes=1;
                    TSname=TSob.Name;

                    try       Sepfind=strfind(TSname,'-');
                        TSob.Name=TSname(Sepfind(end)+1:end);
                    catch
                    end
                case 'Sequential'
                    Zerotimes=0;

                    try    TSname=TSob.Name;
                        Sepfind=strfind(TSname,'-');
                        TSob.Name=TSname(Sepfind(end)+1:end);
                    catch
                    end

                    Tempfig.Sig(count).fullplot=plot(TSob,'--','color',[0.8 0.8 0.8]*(N_T/length(Trial_TSMult)),'DisplayName',[Trial_TS.Info.RunID ' - ' TSob.Name]);

                    Tempfig.Sig(count).fullplot(1).DataTipTemplate.DataTipRows(end+1) = dataTipTextRow('Trace',repmat({Tempfig.Sig(count).fullplot(1).DisplayName},size(Tempfig.Sig(count).fullplot(1).XData)));
            end



            EvtTimes=Trial_TS.Info.Repliction_times;
            tempcount=1;
            for n=RepstoInclude

                if or(tempcount>1,Zerotimes==0)
                    hold on
                end
                try
                    SubOb.evt(n)=getsampleusingtime(TSob,EvtTimes(n)-app.PreTime,EvtTimes(n)+app.PostTime);
                    if Zerotimes
                        SubOb.evt(n).Time=SubOb.evt(n).Time-EvtTimes(n);
                        SubOb.evt(n).Events(n).Time=0;
                        SubOb.evt(n).Events=SubOb.evt(n).Events(n);
                        SubOb.evt(n).Name=TSob.Name;
                        SubOb.evt(n).UserData=TSob.UserData;
                        SubOb.evt(n).DataInfo=TSob.DataInfo;
                    end
                    ltemp=plot(SubOb.evt(n));
                    ltemp(1).DisplayName=[Trial_TS.Info.RunID ' - Subtrial ' num2str(n)];
                    ltemp(1).DataTipTemplate.DataTipRows(end+1) = dataTipTextRow('Trace',repmat({ltemp(1).DisplayName},size(ltemp(1).XData)));
                    Tempfig.Sig(count).RepPlot(n)=ltemp(1);


                catch
                end
                Tempfig.axes(count).Title.String=TSob.Name;
                tempcount=tempcount+1;
            end
            hold off
            Tempfig.leg(count)=legend(Tempfig.axes(count),'-DynamicLegend');
            count=count+1;

            set(findall(Tempfig.fighandle,'-property','FontName'),'FontName','Times New Roman');
            set(findall(Tempfig.fighandle,'-property','FontSize'),'FontSize',10);
            set(findall(Tempfig.fighandle,'-property','Interpreter'),'Interpreter','none');
            grid on;
        end

        function Tempfig = PlotWSContours(app,Tempfig,TSob,N_plots,count,RepstoInclude,PlotStyle,ReusePlot,N_T)
            Trial_TSMult=app.TrialDataMult;
            Trial_TS=Trial_TSMult(N_T);
            if ~ReusePlot
                Tempfig.axes(count)=subplot(N_plots,1,count);
            else
                axes(Tempfig.axes(count));
                hold on
            end

            corder=[
                0    0.4470    0.7410
                0.9290    0.6940    0.1250
                0.4660    0.6740    0.1880
                0.6350    0.0780    0.1840
                0.8500    0.3250    0.0980
                0.4940    0.1840    0.5560
                0.3010    0.7450    0.9330
                0    0.4470    0.7410
                0.9290    0.6940    0.1250
                0.4660    0.6740    0.1880
                0.6350    0.0780    0.1840
                0.8500    0.3250    0.0980
                0.4940    0.1840    0.5560
                0.3010    0.7450    0.9330];
            cindex=1;
            Trial_TS=app.TrialDataMult(N_T);
            switch PlotStyle
                case 'Overlay'
                    Zerotimes=1;
                    TSname=TSob.Name;

                    try       Sepfind=strfind(TSname,'-');
                        TSob.Name=TSname(Sepfind(end)+1:end);
                        Tempfig.axes(count).Title.String=TSob.Name;
                    catch
                    end
                case 'Sequential'
                    Zerotimes=0;

                    try    TSname=TSob.Name;
                        Sepfind=strfind(TSname,'-');
                        TSob.Name=TSname(Sepfind(end)+1:end);
                    catch
                    end
                    %                     [null Tempfig.Sig(count).fullplot]=contour(TSob.Time,TSob.UserData.LocationInfo.Z,TSob.Data',1,'LineStyle','--','color',[0.8 0.8 0.8],'DisplayName',TSob.Name);
                    null=contourc(TSob.Time,TSob.UserData.LocationInfo.Z,double(TSob.Data'),1);
                    null(:,null(2,:)>max(TSob.UserData.LocationInfo.Z))=[];
                    Tempfig.Sig(count).fullplot=plot(null(1,:),null(2,:),'.','color',[0.8 0.8 0.8],'DisplayName',[Trial_TS.Info.RunID '- ' TSob.Name]); cindex=2;
            end



            EvtTimes=Trial_TS.Info.Repliction_times;
            tempcount=1;

            for n=RepstoInclude

                if or(tempcount>1,Zerotimes==0)
                    hold on
                end
                %                 try
                idx_timestograb=find(and(TSob.Time>=EvtTimes(n)-app.PreTime,TSob.Time<=EvtTimes(n)+app.PostTime));
                SubOb.evt(n)=TSob;

                SubOb.evt(n).Time=TSob.Time(idx_timestograb);
                SubOb.evt(n).Data=TSob.Data(idx_timestograb,:);
                %                 [~, idx_start]=min(abs(SubOb.evt(n).Time-EvtTimes(n)));
                if Zerotimes
                    SubOb.evt(n).Time=SubOb.evt(n).Time-EvtTimes(n);

                    SubOb.evt(n).Name=TSob.Name;
                    SubOb.evt(n).UserData=TSob.UserData;
                    SubOb.evt(n).DataInfo=TSob.DataInfo;
                end

                [~, ltemp]=contour(SubOb.evt(n).Time,SubOb.evt(n).UserData.LocationInfo.Z,SubOb.evt(n).Data',1,'Color',corder(cindex,:));
                hold on
                if Zerotimes==0
                    plot(EvtTimes(n),0,'ok','MarkerFaceColor','r','HandleVisibility','off');
                else
                    plot(0,0,'ok','MarkerFaceColor','r','HandleVisibility','off');
                end
                hold off
                title(TSob.Name);
                ltemp(1).DisplayName=[Trial_TS.Info.RunID ' - Subtrial ' num2str(n)];
                Tempfig.Sig(count).RepPlot(n)=ltemp(1);
                %                 catch ME
                %                 end
                tempcount=tempcount+1;
                cindex=cindex+1;
            end
            hold off
            Tempfig.leg(count)=legend(Tempfig.axes(count),'-DynamicLegend');
            Tempfig.leg(count).Interpreter='none';
            xlabel('Time, s');
            ylabel('Z, mm');
            title(TSob.Name);
            count=count+1;
            set(findall(Tempfig.fighandle,'-property','FontSize'),'FontSize',10);
            set(findall(Tempfig.fighandle,'-property','FontName'),'FontName','Times New Roman');
            set(findall(Tempfig.fighandle,'-property','Interpreter'),'Interpreter','none');
            grid on
        end

        function ThreeDFig=Plot3DHWB(app)

            X.WestWall=-3633;
            X.EastWall=36453;
            X.BeachTop=-3633;
            X.Knuckle=6080-3633;
            X.End=6080+7180-3633;

            Y.Northwall=10000;
            Y.Southwall=-10000;

            Z.BeachTop=452.4;
            Z.Knuckle=-298.7;
            Z.End=-1681.8;
            Z.Bottom=-2935.8;
            Z.walltop=1333.8;

            %% Create patch node coordinates for each wall
            % Walls
            Walls.West.X=X.WestWall*ones(4,1);
            Walls.West.Y=[Y.Northwall Y.Northwall Y.Southwall Y.Southwall]';
            Walls.West.Z=[Z.Bottom Z.walltop Z.walltop Z.Bottom]';

            Walls.East.X=X.EastWall*ones(4,1);
            Walls.East.Y=Walls.West.Y;
            Walls.East.Z=Walls.West.Z;


            Walls.North.X=[X.WestWall X.WestWall X.EastWall X.EastWall]';
            Walls.North.Y=Y.Northwall*ones(4,1);
            Walls.North.Z=Walls.West.Z;

            Walls.South.X=Walls.North.X;
            Walls.South.Y=Y.Southwall*ones(4,1);
            Walls.South.Z=Walls.North.Z;

            % Basin floor
            Bottom.X=Walls.South.X;
            Bottom.Z=Z.Bottom*ones(4,1);
            Bottom.Y=[Y.Northwall Y.Southwall Y.Southwall Y.Northwall]';

            % Beach panels
            Beach.Upper.X=[X.WestWall X.WestWall X.Knuckle X.Knuckle]';
            Beach.Upper.Y=[Y.Northwall Y.Southwall Y.Southwall Y.Northwall]';
            Beach.Upper.Z=[Z.BeachTop Z.BeachTop Z.Knuckle Z.Knuckle]';

            Beach.Lower.X=[X.Knuckle X.Knuckle X.End X.End]';
            Beach.Lower.Y=Beach.Upper.Y;
            Beach.Lower.Z=[Z.Knuckle Z.Knuckle Z.End Z.End]';

            % Still waterline
            SWL.X=Bottom.X;
            SWL.Y=Bottom.Y;
            SWL.Z=zeros(4,1);

            %% Draw patches on 3D axes

            ThreeDFig=figure('Name','MQS Path');

            Water=patch('XData',SWL.X,'YData',SWL.Y,'ZData',SWL.Z,'facecolor','b','facealpha',0.3);
            hold on
            Northwall=patch('XData',Walls.North.X,'YData',Walls.North.Y,'ZData',Walls.North.Z,'facecolor',[0.5 0.5 0.5],'facealpha',0.3);
            Westwall=patch('XData',Walls.West.X,'YData',Walls.West.Y,'ZData',Walls.West.Z,'facecolor',[0.5 0.5 0.5]*1.5,'facealpha',0.3);
            Eastwall=patch('XData',Walls.East.X,'YData',Walls.East.Y,'ZData',Walls.East.Z,'facecolor',[0.5 0.5 0.5]*1.5,'facealpha',0.3);
            Southwall=patch('XData',Walls.South.X,'YData',Walls.South.Y,'ZData',Walls.South.Z,'facecolor',[0.5 0.5 0.5]*1.5,'facealpha',0.3);
            BeachLowerSection=patch('XData',Beach.Lower.X,'YData',Beach.Lower.Y,'ZData',Beach.Lower.Z,'facecolor',[0.5 0.5 0.5]);
            BeachUpperSection=patch('XData',Beach.Upper.X,'YData',Beach.Upper.Y,'ZData',Beach.Upper.Z,'facecolor',[0.5 0.5 0.5]);
            daspect([1 1 1]);
        end



        function Tfig = EnsemblePlot(app,Trial_TS_mult,Dtype,PlotField,Reps_mult,N_plots,FigName)
            N_trials=length(Trial_TS_mult);
            Tfig.fighandle=figure('Name',FigName);
            for j=1:N_plots
                clear DataBlock DataMean DataStd
                count=1;
                dT=1/Trial_TS_mult(1).(Dtype).(PlotField{j}).UserData.SamplingInfo.Sample_Rate;
                Ts=[-app.PreTime:dT:app.PostTime]';
                for N_T=1:N_trials
                    RepstoInclude=Reps_mult{N_T};
                    Trial_TS=Trial_TS_mult(N_T);

                    TSob=Trial_TS.(Dtype).(PlotField{j});
                    try    TSname=TSob.Name;
                        Sepfind=strfind(TSname,'-');
                        TSob.Name=TSname(Sepfind(end)+1:end);
                    catch
                    end
                    for n_reps=RepstoInclude
                        T_int=Trial_TS.Info.Repliction_times(n_reps)+Ts;
                        TSExcerpt=resample(TSob,T_int);
                        DataBlock(:,count)=TSExcerpt.Data;
                        count=count+1;
                    end
                end
                [null indzero]=min(abs(Ts));
                DataMean=nanmean(DataBlock,2);
                DataStd=nanstd(DataBlock,0,2);
                Tfig.axes(j)=subplot(length(PlotField),1,j);
                title(TSob.Name);
                pp=patch([Ts;flipud(Ts)],[DataMean-DataStd; flipud(DataMean+DataStd)],'b');
                pp.EdgeColor='none';
                pp.FaceAlpha=0.5;
                hold on
                plot(Ts,DataMean,'k','LineWidth',1);

                plot(0,DataMean(indzero),'ok','MarkerFaceColor','r','HandleVisibility','off');

                xlabel('Time, s');
                ylabel([TSExcerpt.Name ' (' TSExcerpt.DataInfo.Units ')']);
                set(Tfig.fighandle,'Color','w');
                Tfig.leg=legend({'+/- Stddev','Mean'});
                set(findall(Tfig.fighandle,'-property','FontName'),'FontName','Times New Roman');
                set(findall(Tfig.fighandle,'-property','FontSize'),'FontSize',10);
                grid on
            end
        end

        function Tfig = FFTPlot(app,Trial_TS_mult,Dtype,PlotField,Reps_mult,N_plots,FigName)
            N_trials=length(Trial_TS_mult);
            Tfig.fighandle=figure('Name',FigName);
            for j=1:N_plots
                clear DataBlock DataMean DataStd
                count=1;
                dT=1/Trial_TS_mult(1).(Dtype).(PlotField{j}).UserData.SamplingInfo.Sample_Rate;
                Ts=[-app.PreTime:dT:app.PostTime]';
                for N_T=1:N_trials
                    RepstoInclude=Reps_mult{N_T};
                    Trial_TS=Trial_TS_mult(N_T);

                    TSob=Trial_TS.(Dtype).(PlotField{j});
                    try    TSname=TSob.Name;
                        Sepfind=strfind(TSname,'-');
                        TSob.Name=TSname(Sepfind(end)+1:end);
                    catch
                    end
                    for n_reps=RepstoInclude
                        T_int=Trial_TS.Info.Repliction_times(n_reps)+Ts;
                        TSExcerpt=resample(TSob,T_int);
                        DataBlock(:,count)=TSExcerpt.Data;
                        names{count}=[Trial_TS.Info.RunID ' - Rep' num2str(n_reps)];
                        count=count+1;
                    end
                end
                DataBlock(isnan(DataBlock))=0;
                FFTall=abs(fft(DataBlock));
                FFTmean=nanmean(FFTall,2);
                Nfft=length(FFTall);
                ff=[1:Nfft]'/Nfft*TSob.UserData.SamplingInfo.Sample_Rate;
                Tfig.axes(j)=subplot(length(PlotField),1,j);
                for n_p=1:size(DataBlock,2)
                    hold on
                    semilogy(ff,FFTall(:,n_p),'DisplayName',names{n_p})
                end
                plot(ff,FFTmean,'k','LineWidth',1.5,'DisplayName','Averaged FFT');
                title(TSob.Name);
                xlabel('Frequency, Hz');
                ylabel([TSExcerpt.Name ' (' TSExcerpt.DataInfo.Units ')']);
                xlim(ff([1 round(Nfft/2)]))
                Tfig.axes(j).YScale='log';
                Tfig.leg=legend('-dynamiclegend');
                set(Tfig.fighandle,'Color','w');
                set(findall(Tfig.fighandle,'-property','FontName'),'FontName','Times New Roman');
                set(findall(Tfig.fighandle,'-property','FontSize'),'FontSize',10);
            end
        end

        function [datablock,Printedname,units] = GetInterpolatedDataBlock(app)
            fwait=waitbar(0,'Building Data Block');
            stackcount = 1;

            PlottedReps=app.SelectSubTrialsListBox.Value;
            Trial_TS_mult=app.TrialDataMult;
            N_Trials=length(Trial_TS_mult);


            Trial_TS=app.TrialData;
            try  TSonly=rmfield(Trial_TS,'NonTS');
            catch
                TSonly=Trial_TS;
            end
            TSonly=rmfield(TSonly,'Info');
            Datatypes=fieldnames(TSonly);
            Datatypes=fieldnames(TSonly);


            for n_d=1:length(Datatypes)
                signallist_master{n_d}=fieldnames(Trial_TS.(Datatypes{n_d}));
            end

            for N_T=1:N_Trials
                waitbar(N_T/N_Trials,fwait);
                clearvars -except app fname* N_T* fpath PlottedReps Printedname units fwait Trial_TS* PlottedReps InterpOption Datatypes signallist_master stackcount datablock
                Trial_TS=Trial_TS_mult(N_T);
                RunID=Trial_TS.Info.RunID;
                plottedReps_curr=PlottedReps(contains(PlottedReps,RunID));
                RepstoInclude=[];
                for j=1:length(plottedReps_curr)
                    temp=plottedReps_curr{j};
                    breaks=strfind(temp,';');
                    breaksdash=strfind(temp,'-');
                    TrialReps{j}=temp(1:breaks-1);
                    RepstoInclude(j)=str2double(temp(breaksdash+1:breaks-1));
                end
                RepstoInclude=sort(RepstoInclude);

                EvtTimes=Trial_TS.Info.Repliction_times;

                try  TSonly=rmfield(Trial_TS,'NonTS');
                catch
                    TSonly=Trial_TS;
                end
                TSonly=rmfield(TSonly,'Info');



                for n_rep=RepstoInclude

                    for n_d=1:length(Datatypes)
                        signallist=signallist_master{n_d};
                        for n_s=1:length(signallist)
                            Sub_TS.(Datatypes{n_d}).(signallist{n_s})=resample(Trial_TS.(Datatypes{n_d}).(signallist{n_s}),[EvtTimes(n_rep)-app.PreTime:0.01:EvtTimes(n_rep)+app.PostTime]);
                        end
                    end


                    try
                        t_common=Sub_TS.ManeuveringInputs.Thrust.Time;
                    catch
                        t_common=Sub_TS.WaveGauges.WaveGauge1.Time;
                    end

                    t_common0=t_common-EvtTimes(n_rep);

                    datablock(:,1,stackcount)=t_common0;
                    units{1}='Seconds';
                    Printedname{1}='Time after model release';

                    datablock(:,2,stackcount)=t_common;
                    units{2}='Seconds';
                    Printedname{2}='Absolute Time';

                    count=3;
                    for n_d=1:length(Datatypes);

%                         if stackcount==1;
%                         signallist=fieldnames(Trial_TS.(Datatypes{n_d}));
%                         end
                         signallist=signallist_master{n_d};
                        for n_s=1:length(signallist)
                            
                            Printedname{count}=[Datatypes{n_d} ' - ' signallist{n_s}];
                            
                            tsresample=resample(Sub_TS.(Datatypes{n_d}).(signallist{n_s}),t_common,'linear');
                            datablock(:,count,stackcount)=tsresample.Data;
                            units{count}=tsresample.DataInfo.Units;
                            try
                                LocationsX{count}=Trial_TS.(Datatypes{n_d}).(signallist{n_s}).UserData.LocationInfo.X;

                            catch
                                LocationsX{count}=' ';
                            end
                            try
                                LocationsY{count}=Trial_TS.(Datatypes{n_d}).(signallist{n_s}).UserData.LocationInfo.Y;
                            catch
                                LocationsY{count}=' ';
                            end
                            count=count+1;
                        end
                    end
                    stackcount=stackcount+1;
                end
                end
            close(fwait)
        end

        function COV = calculateCovarianceTimeData(app,X,timedata)
            %This function takes in two vairables that both change with time (e.g. X(t)
            %and timedata(t)) and calculates the covariance at each time step.
            %inputs: X n*m time dependent vector of data
            %        timedata n*m time dependent vecotr of data
            %outputs: cov and n*1 cell array where each cell is a 2x2 covariance matrix

            nt = length(X);
            COV = cell(nt,1);
            for j=1:nt
                COV{j} = cov(X(j,:),timedata(j,:),1,'partialrow');
            end
        end

        function ellipse = calculateEllipseXY(app,mu,Sigma,Npoints)

            k2 = 1;
            CIRCLE = [];

            if isempty(CIRCLE)
                theta  = linspace(0,2*pi,Npoints);
                CIRCLE = [cos(theta); sin(theta)];
            end

            % eigenvalue decompostion
            [V,D] = eig(full((Sigma+Sigma')/2));

            % compute linear system which transforms unit variance to Sigma
            A = V*(k2*D).^0.5;
            A = real(A);

            % map unit circular covariance to k2 Sigma ellipse
            Y = A*CIRCLE;

            % shift origin to the mean
            x = mu(1) + Y(1,:)';
            y = mu(2) + Y(2,:)';
            ellipse = [x, y];
        end

        function [ff] = Plot_XY_Ensemble(app,X,timedata,Covariance,labels,units)
      
            plotme = 0;

           Aspectratio=(max(X)-min(X))/(max(timedata)-min(timedata));
            tol = 1;
            ff=figure;
            if isa(X,'double')
               
                %Scale Y data to unity range to improve boundary estimation
                scaleC1 = tol*1/(max(timedata)-min(timedata));

                n_points = 31;
                boundary_smoothness = 0.25; %Increase to resolve peaks and valleys. Decrease to reduce "spikiness" in the envelope.
                plot(X,timedata,'-','Color','b','LineWidth',1,'DisplayName',['Ensemble: ' labels.X ' - ' labels.Y '; N=' num2str(labels.N)]);
                xlabel('X(t)-Position (m)');
                %ylabel(label);
                %legend({strcat(barelabel,'-',descriptor)})
                if any(cell2mat(Covariance),'all')
                    stdOutline_c1=[];
                    for nt=1:length(timedata)
                        Sigma = Covariance{nt};
                        localStdOutline = app.calculateEllipseXY([X(nt),timedata(nt)],Sigma,n_points);
                        stdOutline_c1 = [stdOutline_c1;localStdOutline];
                    end
                    if plotme == 1 %for debugging
                        hold on
                        plot(stdOutline_c1(:,1),stdOutline_c1(:,2),'ko');
                    end
                    stdOutline_c1(:,2) = scaleC1*stdOutline_c1(:,2);
                    ind_Boundary = boundary(stdOutline_c1(:,1),stdOutline_c1(:,2),boundary_smoothness);
                    stdOutline_c1(:,2) = 1/scaleC1*stdOutline_c1(:,2);
                    stdOutline_c1_bound = stdOutline_c1(ind_Boundary,:);
                    if plotme == 1 %for debugging
                        plot(stdOutline_c1_bound(:,1),stdOutline_c1_bound(:,2),'b.');
                    end
                    env_c1 = patch('XData',stdOutline_c1_bound(:,1),'YData',stdOutline_c1_bound(:,2),'FaceColor','b','EdgeColor','none'); % Adds Display name: 'DisplayName',strcat('SD-',descriptor));
                    alpha(env_c1,0.4);
                end
                set(gca,'children',flipud(get(gca,'children'))); %reverses draw order to put patch at the back
                %legend('Location','northoutside','NumColumns',2)
                xlabel([labels.X '[' units.X ']']);
                ylabel([labels.Y '[' units.Y ']']);
            end
set(findall(ff,'-property','FontName'),'FontName','Times New Roman');
            set(findall(ff,'-property','FontSize'),'FontSize',10);
            set(findall(ff,'-property','Interpreter'),'Interpreter','none');
            set(ff,'Color','w');
        end
    end


    methods (Access = public)

        function results = OpenVid(app,hObject,eventData,FullVidTable)
            selectedLink=FullVidTable.Var3(eventData.Indices(1));
            web(selectedLink{1});
            results=1;
        end

        function results = OpenMultiFiles(app,fpath,fname)
            % This function cycles through selected files in the 'fnames'
            % cell array and loads them into an N-dimensional data
            % structure. Metadata from each trial are loaded into a cell
            % array
            for j=1:length(fname)
                load([fpath fname{j}]);
                TS{j}=Trial_TS;
                fn{j}=fieldnames(Trial_TS);
                RunID{j}=fname{j}(1:5);
            end

            ftemp=intersect(fn{1},fn{1});
            for j=2:length(TS);
                ftemp=intersect(ftemp,fn{j});
            end

            clear Trial_TS

            for j=1:size(TS,2)
                for n_d=1:length(ftemp);
                    Trial_TS(j).(ftemp{n_d})=TS{j}.(ftemp{n_d});
                end
                Trial_TS(j).Info.RunID=RunID{j};
            end
            app.FilesCurrentlyOpenListBox.Items=fname;
            app.TrialData=Trial_TS(1);
            app.TrialDataMult=Trial_TS;
            for j=1:length(Trial_TS)
                Vals{1,j}=RunID{j};
                Vals{2,j}=Trial_TS(j).Info.WaveCondition;
                Vals{3,j}=Trial_TS(j).Info.WaveFrequency;
                Vals{4,j}=Trial_TS(j).Info.WaveMakerStroke;
                Vals{5,j}=Trial_TS(j).Info.Direction;
                Vals{6,j}=Trial_TS(j).Info.Periods_to_Release;
                Vals{7,j}='';
                Vals{8,j}=[num2str(Trial_TS(j).Info.Auto_Marine_Drive) ' (' num2str(round(100*Trial_TS(j).Info.Auto_Marine_Drive/255,2)) '%)'];
                Vals{9,j}=[num2str(Trial_TS(j).Info.Auto_Land_Drive) ' (' num2str(round(100*Trial_TS(j).Info.Auto_Land_Drive/255,2)) '%)'];
                Vals{10,j}=Trial_TS(j).Info.Auto_Land_Drive_Time;
                Vals{11,j}=Trial_TS(j).Info.Auto_Wheels_Up_Time;
                Vals{12,j}=Trial_TS(j).Info.MET_Duration;
                Vals{13,j}=[num2str(Trial_TS(j).Info.Auto_Land_Steer) ' (' num2str(round((Trial_TS(j).Info.Auto_Land_Steer-128)/128,2)) '%)'];
                Vals{14,j}=Trial_TS(j).Info.Auto_Land_Steer_Time;
                Vals{15,j}=[num2str(Trial_TS(j).Info.Auto_Marine_Steer) ' (' num2str(round((Trial_TS(j).Info.Auto_Marine_Steer-128)/128,2)) '%)'];
                Vals{16,j}=Trial_TS(j).Info.Auto_Marine_Steer_Time;
                Vals{17,j}=Trial_TS(j).Info.N_replications;
                Vals{18,j}=Trial_TS(j).Info.Comments;
                Vals{19,j}=Trial_TS(j).Info.NRLComments;
            end


            ValNames={'Run number:', ...
                'Wave condition:', ...
                '   Wave frequency ' ...
                '   Wavemaker stroke: ' ...
                'Direction: ' ...
                'Wave Periods to Model Release:' ...
                'Auto Drive Parameters: ' ...
                '   Auto_Marine_Drive:  ' ...
                '   Auto_Land_Drive:  ' ...
                '   Auto_Land_Drive_Time ' ...
                '   Auto_Wheels_Up_Time: ' ...
                '   MET: ' ...
                '   Auto_land_steer: ' ...
                '   Auto_land_steer_time: ' ...
                '   Auto_marine_steer: ' ...
                '   Auto_marine_steer_time ' ...
                'Number of sub-trials: ' ...
                'Comments (Iowa):' ...
                'Comments (NRL):'};

            Vals(:,length(Trial_TS)+1)={'','','Hz','mm','','Periods','','','','s','s','s','','s','+ to STBD','s','','',''}';


            InfoTable=cell2table(Vals);
            app.UITable.Data=InfoTable;
            app.UITable.RowName=ValNames;
            s = uistyle('HorizontalAlignment','left');
            addStyle(app.UITable,s,'table','')
            results=1;
        end

        function SigTable = CreateSigTable(app,N_T)
            if N_T==0;
                Trial_TS=app.TrialData;
            else
                Trial_TS=app.TrialDataMult(N_T);
            end
            Datatypes=fieldnames(Trial_TS);
            idxInfo=find(contains(Datatypes,'Info'));
            Datatypes(idxInfo)=[];
            count=1;

            %             liststring=sprintf('\t %s \t (%s) \t\t\t\t %s','Signal','Units','Description');
            for n_D=1:length(Datatypes)
                sigtypes=fieldnames(Trial_TS.(Datatypes{n_D}));
                for n_s=1:length(sigtypes)
                    SignalCategory{count}=Datatypes{n_D};
                    SignalName{count}=sigtypes{n_s};
                    try
                        Units{count}=Trial_TS.(Datatypes{n_D}).(sigtypes{n_s}).DataInfo.Units;
                        Description{count}=Trial_TS.(Datatypes{n_D}).(sigtypes{n_s}).UserData.Description;
                        try
                            SampleRate{count}=num2str(Trial_TS.(Datatypes{n_D}).(sigtypes{n_s}).UserData.SamplingInfo.Sample_Rate);
                        catch SampleRate{count}='-';
                        end
                        try
                            BitDepth{count}=num2str(Trial_TS.(Datatypes{n_D}).(sigtypes{n_s}).UserData.SamplingInfo.Bit_depth);
                        catch BitDepth{count}='-';
                        end
                    catch
                        try
                            Units{count}=Trial_TS.(Datatypes{n_D}).(sigtypes{n_s}).WaveStaff1.DataInfo.Units;
                            Description{count}=Trial_TS.(Datatypes{n_D}).(sigtypes{n_s}).WaveStaff1.UserData.Description;
                            try
                                SampleRate{count}=num2str(Trial_TS.(Datatypes{n_D}).(sigtypes{n_s}).WaveStaff1.UserData.SamplingInfo.Sample_Rate);
                            catch                                 SampleRate{count}='-';
                            end
                            try
                                BitDepth{count}=num2str(Trial_TS.(Datatypes{n_D}).(sigtypes{n_s}).WaveStaff1.UserData.SamplingInfo.Bit_depth);
                            catch BitDepth{count}='-';
                            end
                        catch
                            Units{count}='-';
                            Description{count}='No Description Provided';
                            BitDepth{count}='-';
                            SampleRate{count}='-';
                        end
                    end
                    count=count+1;
                end
            end
            SigTable=table(SignalCategory',SignalName',Units',SampleRate',BitDepth',Description');
            SigTable.Properties.VariableNames={'Signal Type','Signal Name','Units','Sample Rate','Bit Depth','Description'};
        end
    end

    % Callbacks that handle component events
    methods (Access = private)

        % Button pushed function: OpenSingleTrialButton
        function OpenSingleTrialButtonPushed(app, event)
            % This function opens a UI window for the user to select one or
            % more trials, which are then loaded into memory and used to
            % populte the GUI listboxes.

            if app.GroupLoaded==1;
                fpath=app.GroupPath;
                fname=fieldnames(app.GroupSet);
            else
                [fname, fpath]=uigetfile('*.mat','MultiSelect','on');
            end

            if fpath~=0;

                if ischar(fname)
                    fname={fname};
                end


                app.MultiRuns=1;
                [null]=OpenMultiFiles(app,fpath,fname);

                app.FilePath=fpath;
                app.FileLoadedName=fname;

                Trial_TS=app.TrialData;
                Massprops=Trial_TS.Info.MassProps;
                try Ixx=MassProps.Ixx; catch Ixx=nan; end
                try MassProps.Iyy; catch Iyy=nan; end
                try MassProps.Izz; catch Izz=nan; end
                LandProps=[Massprops.Mass;
                    Trial_TS.Info.PoI.COG.Land(:); ...
                    Trial_TS.Info.PoI.IMU(:);
                    Trial_TS.Info.MassProps.MOI.Land.Ixx0; ...
                    Trial_TS.Info.MassProps.MOI.Land.Iyy0; ...
                    Trial_TS.Info.MassProps.MOI.Land.Izz0; ...
                    (Trial_TS.Info.MassProps.MOI.Land.Ixx0/Massprops.Mass)^0.5; ...
                    (Trial_TS.Info.MassProps.MOI.Land.Iyy0/Massprops.Mass)^0.5; ...
                    (Trial_TS.Info.MassProps.MOI.Land.Izz0/Massprops.Mass)^0.5];

                MarineProps=[Massprops.Mass;
                    Trial_TS.Info.PoI.COG.Marine(:); ...
                    Trial_TS.Info.PoI.IMU(:);
                    Trial_TS.Info.MassProps.MOI.Land.Ixx0; ...
                    Trial_TS.Info.MassProps.MOI.Marine.Iyy0; ...
                    Trial_TS.Info.MassProps.MOI.Marine.Izz0; ...
                    (Trial_TS.Info.MassProps.MOI.Marine.Ixx0/Massprops.Mass)^0.5; ...
                    (Trial_TS.Info.MassProps.MOI.Marine.Iyy0/Massprops.Mass)^0.5; ...
                    (Trial_TS.Info.MassProps.MOI.Marine.Izz0/Massprops.Mass)^0.5];

                Units={'kg','mm','mm','mm','mm','mm','mm','kg-m^2','kg-m^2','kg-m^2','m','m','m'}';

                app.MassTable.ColNames={'Land Mode', 'Marine Mode','Units'};
                app.MassTable.RowNames={'Mass','CoG - X', 'CoG - Y', 'CoG - Z', 'IMU - X', 'IMU - Y', 'IMU - Z', 'Ixx,0', 'Iyy,0', 'Izz,0', 'Rxx', 'Ryy', 'Rzz'};

                try
                    app.MassTable.Data=table(LandProps,MarineProps,Units);
                catch
                end

                %% Kinematics
                app.AccelerationsListBox.Items=cellstr(num2str([]));
                app.AngularRatesListBox.Items=cellstr(num2str([]));
                try
                    app.AccelerationsListBox.Items=fieldnames(Trial_TS.Accel);
                    app.AccelerationsListBox.Multiselect='on';

                    app.AngularRatesListBox.Items=fieldnames(Trial_TS.AngularRates);
                    app.AngularRatesListBox.Multiselect='on';
                catch
                end

                app.PositionXYZListBox.Items=cellstr(num2str([]));
                app.OrientationListBox.Items=cellstr(num2str([]));
                try
                    app.PositionXYZListBox.Items=fieldnames(Trial_TS.Position);
                    app.PositionXYZListBox.Multiselect='on';

                    app.OrientationListBox.Items=fieldnames(Trial_TS.Orientation);
                    app.OrientationListBox.Multiselect='on';
                catch
                end

                app.PositionXYZGapFilledListBox.Items=cellstr(num2str([]));
                app.OrientationGapFilledListBox.Items=cellstr(num2str([]));
                app.VelocityGapFilledListBox.Items=cellstr(num2str([]));
                try
                    app.PositionXYZGapFilledListBox.Items=fieldnames(Trial_TS.Position_Gapfilled);
                    app.PositionXYZGapFilledListBox.Multiselect='on';

                    app.OrientationGapFilledListBox.Items=fieldnames(Trial_TS.Orientation_Gapfilled);
                    app.OrientationGapFilledListBox.Multiselect='on';

                    app.VelocityGapFilledListBox.Items=fieldnames(Trial_TS.Velocities_Gapfilled);
                    app.VelocityGapFilledListBox.Multiselect='on';
                catch
                end

                try
                    %% Model inputs
                    app.LoggedActuationListBox.Items=cellstr(num2str([]));
                    app.LoggedActuationListBox.Items=fieldnames(Trial_TS.ManeuveringInputs);
                    app.LoggedActuationListBox.Multiselect='on';
                catch
                end

                try
                    %% Body-fixed UVW velocities
                    app.VelocityBodyFixedListBox.Items=cellstr(num2str([]));
                    app.VelocityBodyFixedListBox.Items=fieldnames(Trial_TS.Body_UVW);
                    app.VelocityBodyFixedListBox.Multiselect='on';
                catch
                end

                try
                    %% Ground Contact Metrics
                    app.GroundContactListBox.Items=cellstr(num2str([]));
                    app.GroundContactListBox.Items=fieldnames(Trial_TS.GroundContact);
                    app.GroundContactListBox.Multiselect='on';
                catch
                end

                %% ROS Commands
                app.ROSCommandsListBox.Items=cellstr(num2str([]));
                try
                    app.ROSCommandsListBox.Items=fieldnames(Trial_TS.ROSCommands);
                    app.ROSCommandsListBox.Multiselect='on';

                catch
                end

                %% Wave data
                app.DeepWaterAcousticsListBox.Items=cellstr(num2str([]));
                try
                    app.DeepWaterAcousticsListBox.Items=fieldnames(Trial_TS.WaveGauges);
                    app.DeepWaterAcousticsListBox.Multiselect='on';
                catch
                end

                app.RAWBreakerMeasurementsListBox.Items=cellstr(num2str([]));
                try
                    app.RAWBreakerMeasurementsListBox.Items=fieldnames(Trial_TS.NonTS.DeltaFluid_field);
                    app.RAWBreakerMeasurementsListBox.Multiselect='on';
                catch
                end

                app.FusedBreakerMeasurementsListBox.Items=cellstr(num2str([]));
                try
                    app.FusedBreakerMeasurementsListBox.Items=fieldnames(Trial_TS.NonTS.DeltaFluid_field_fused);
                    app.FusedBreakerMeasurementsListBox.Multiselect='on';
                catch
                end

                if app.MultiRuns
                    Trial_Mult=app.TrialDataMult;
                    stcount=1;
                    for n_T=1:length(Trial_Mult)
                        for n=1:Trial_Mult(n_T).Info.N_replications
                            SubTrial{stcount}=[Trial_Mult(n_T).Info.RunID '-'  num2str(n) '; ' num2str(Trial_Mult(n_T).Info.Repliction_times(n)) ' s'];
                            stcount=stcount+1;
                        end
                    end
                else
                    for n=1:Trial_TS.Info.N_replications
                        SubTrial{n}=[num2str(n) '; ' num2str(Trial_TS.Info.Repliction_times(n)) ' s'];
                    end
                end

                app.SelectSubTrialsListBox.Items=SubTrial;
                app.SelectSubTrialsListBox.Multiselect='on';
                if app.GroupLoaded; % Selects those sub-trials that have been clustered together for the same experiment conditions.
                    RunSet=app.GroupSet;
                    PreSelect=[];
                    RunsToLoad=fieldnames(RunSet);
                    Offset=0;
                    for n_run=1:length(RunsToLoad)
                        PreSelect=[PreSelect RunSet.(RunsToLoad{n_run})+Offset];
                        Offset=Offset+Trial_Mult(n_run).Info.N_replications;
                    end
                    app.SelectSubTrialsListBox.Value=SubTrial(PreSelect);

                end

                if ~Trial_TS.Info.IncludedData.NRLSenix
                    app.AcousticGaugesCheckBox.Value=0;
                end

                app.TrialData=Trial_TS;
                app.GroupLoaded=0;
            end
        end

        % Button pushed function: PlotSelectionButton
        function PlotSelectionButtonPushed(app, event)
            % This callback plots the subset of selected sub-trials and
            % signals.
            try
                tempfighandles=[app.Timefig(:).fighandle];
                close(tempfighandles);
            catch
            end
            AllAxes=[];
            if app.SubTrialsOverlaidT0atstartofeachsubtrialButton.Value
                PlottingStyle='Overlay';
            end
            if app.SubTrialsSequentialT0atstartofrunButton.Value
                PlottingStyle='Sequential';
            end

            PlottedReps=app.SelectSubTrialsListBox.Value;

            if(~isempty(PlottedReps))

                Trial_TS_mult=app.TrialDataMult;

                N_trials=length(Trial_TS_mult);
                tempcount=1; % Count for trajectory overlay
                TrialCount=1;
                Timefig=[];
                for N_T=1:N_trials
                    RepstoInclude=[];

                    if TrialCount==1
                        ReusePlot=0;
                    else ReusePlot=1;
                    end
                    Trial_TS=Trial_TS_mult(N_T);
                    RunID=Trial_TS.Info.RunID;
                    plottedReps_curr=PlottedReps(contains(PlottedReps,RunID));

                    if ~isempty(plottedReps_curr);
                        for j=1:length(plottedReps_curr)
                            temp=plottedReps_curr{j};
                            breaks=strfind(temp,';');
                            breaksdash=strfind(temp,'-');
                            TrialReps{j}=temp(1:breaks-1);
                            RepstoInclude(j)=str2double(temp(breaksdash+1:breaks-1));
                        end
                        RepstoInclude=sort(RepstoInclude);

                        %% Maneuvering Inputs
                        ManeuveringField=app.LoggedActuationListBox.Value;
                        N_plots=length(ManeuveringField);

                        if N_plots>0
                            if TrialCount==1
                                Tfig.fighandle=figure('Name','Maneuvering Commands');
                            else Tfig=Fig1;
                            end
                            for j=1:length(ManeuveringField)
                                TSob=Trial_TS.ManeuveringInputs.(ManeuveringField{j});
                                Tfig = app.PlotTS(Tfig,TSob,N_plots,j,RepstoInclude,PlottingStyle,ReusePlot,N_T);
                            end
                            AllAxes=[AllAxes; Tfig.axes(:)];
                            Fig1=Tfig;
                            Timefig=[Timefig Tfig];
                        end


                        %% MoCap Data - Position
                        clear Tfig
                        PlotFields=app.PositionXYZListBox.Value;
                        N_plots=length(PlotFields);
                        if N_plots>0
                            if TrialCount==1
                                Tfig.fighandle=figure('Name','Positions');
                            else Tfig=Fig2;
                            end
                            for j=1:length(PlotFields)
                                TSob=Trial_TS.Position.(PlotFields{j});
                                Tfig = app.PlotTS(Tfig,TSob,N_plots,j,RepstoInclude,PlottingStyle,ReusePlot,N_T);
                            end

                            AllAxes=[AllAxes; Tfig.axes(:)];
                            Fig2=Tfig;
                            Timefig=[Timefig Tfig];
                        end

                        %% MoCap Data - Position GapFilled
                        clear Tfig
                        PlotFields=app.PositionXYZGapFilledListBox.Value;
                        N_plots=length(PlotFields);
                        if N_plots>0
                            if TrialCount==1
                                Tfig.fighandle=figure('Name','Gap-Filled Position');
                            else Tfig=Fig3;
                            end

                            for j=1:length(PlotFields)
                                TSob=Trial_TS.Position_Gapfilled.(PlotFields{j});
                                Tfig = app.PlotTS(Tfig,TSob,N_plots,j,RepstoInclude,PlottingStyle,ReusePlot,N_T);
                            end

                            AllAxes=[AllAxes; Tfig.axes(:)];
                            Fig3=Tfig;
                            Timefig=[Timefig Tfig];
                        end

                        %% Euler Angles
                        clear Tfig
                        PlotFields=app.OrientationListBox.Value;
                        N_plots=length(PlotFields);
                        if N_plots>0
                            if TrialCount==1
                                Tfig.fighandle=figure('Name','Orientation');
                            else Tfig=Fig4;
                            end

                            for j=1:length(PlotFields)
                                TSob=Trial_TS.Orientation.(PlotFields{j});
                                Tfig = app.PlotTS(Tfig,TSob,N_plots,j,RepstoInclude,PlottingStyle,ReusePlot,N_T);
                            end

                            AllAxes=[AllAxes; Tfig.axes(:)];
                            Fig4=Tfig;
                            Timefig=[Timefig Tfig];
                        end


                        %% Euler Angles - Gap Filled
                        clear Tfig
                        PlotFields=app.OrientationGapFilledListBox.Value;
                        N_plots=length(PlotFields);
                        if N_plots>0
                            if TrialCount==1
                                Tfig.fighandle=figure('Name','Gap-Filled Orientation');
                            else Tfig=Fig5;
                            end

                            for j=1:length(PlotFields)
                                TSob=Trial_TS.Orientation_Gapfilled.(PlotFields{j});
                                Tfig = app.PlotTS(Tfig,TSob,N_plots,j,RepstoInclude,PlottingStyle,ReusePlot,N_T);
                            end

                            AllAxes=[AllAxes; Tfig.axes(:)];
                            Fig5=Tfig;
                            Timefig=[Timefig Tfig];
                        end

                        %% IMU-Accelerations
                        clear Tfig
                        PlotFields=app.AccelerationsListBox.Value;
                        N_plots=length(PlotFields);
                        if N_plots>0
                            if TrialCount==1
                                Tfig.fighandle=figure('Name','Body-Fixed Accelerations');
                            else Tfig=Fig6;
                            end
                            for j=1:length(PlotFields)
                                TSob=Trial_TS.Accel.(PlotFields{j});
                                Tfig = app.PlotTS(Tfig,TSob,N_plots,j,RepstoInclude,PlottingStyle,ReusePlot,N_T);
                            end
                            AllAxes=[AllAxes; Tfig.axes(:)];
                            Fig6=Tfig;
                            Timefig=[Timefig Tfig];
                        end

                        %% IMU-Gyroscope
                        clear Tfig
                        PlotFields=app.AngularRatesListBox.Value;
                        N_plots=length(PlotFields);
                        if N_plots>0
                            if TrialCount==1
                                Tfig.fighandle=figure('Name','Angular Rates');
                            else Tfig=Fig7;
                            end

                            for j=1:length(PlotFields)
                                TSob=Trial_TS.AngularRates.(PlotFields{j});
                                Tfig = app.PlotTS(Tfig,TSob,N_plots,j,RepstoInclude,PlottingStyle,ReusePlot,N_T);
                            end
                            AllAxes=[AllAxes; Tfig.axes(:)];
                            Fig7=Tfig;
                            Timefig=[Timefig Tfig];
                        end

                        %% Velocities
                        clear Tfig;
                        PlotFields=app.VelocityGapFilledListBox.Value;
                        N_plots=length(PlotFields);
                        if N_plots>0
                            if TrialCount==1
                                Tfig.fighandle=figure('Name','Model Velocities');
                            else Tfig=Fig8;
                            end

                            for j=1:length(PlotFields)
                                TSob=Trial_TS.Velocities_Gapfilled.(PlotFields{j});
                                Tfig = app.PlotTS(Tfig,TSob,N_plots,j,RepstoInclude,PlottingStyle,ReusePlot,N_T);
                            end
                            AllAxes=[AllAxes; Tfig.axes(:)];
                            Fig8=Tfig;
                            Timefig=[Timefig Tfig];
                        end


                        %% Deep Water Acoustics
                        clear Tfig;
                        PlotFields=app.DeepWaterAcousticsListBox.Value;
                        N_plots=length(PlotFields);
                        if N_plots>0
                            if TrialCount==1
                                Tfig.fighandle=figure('Name','Deep-Water Acoustic Wave Measurements');
                            else Tfig=Fig9;
                            end
                            for j=1:length(PlotFields)
                                TSob=Trial_TS.WaveGauges.(PlotFields{j});
                                Tfig = app.PlotTS(Tfig,TSob,N_plots,j,RepstoInclude,PlottingStyle,ReusePlot,N_T);
                            end
                            AllAxes=[AllAxes; Tfig.axes(:)];
                            Fig9=Tfig;
                            Timefig=[Timefig Tfig];
                        end

                        %% DeltaFluid-RAW
                        % Determine which (if either) of the raw breaker sensor
                        % outputs to use.
                        if and(app.AcousticGaugesCheckBox.Value,Trial_TS.Info.IncludedData.NRLSenix==1)
                            %% Deep Water Acoustics
                            clear Tfig;
                            PlotFields=app.RAWBreakerMeasurementsListBox.Value;
                            N_plots=length(PlotFields);
                            if N_plots>0
                                if TrialCount==1
                                    Tfig.fighandle=figure('Name','Raw Acoustic Measurement of Breaker Elevations');
                                else Tfig=Fig10a;
                                end
                                for j=1:length(PlotFields)
                                    TSob=Trial_TS.NRLAcoustics.(PlotFields{j});
                                    Tfig = app.PlotTS(Tfig,TSob,N_plots,j,RepstoInclude,PlottingStyle,ReusePlot,N_T);
                                end
                                AllAxes=[AllAxes; Tfig.axes(:)];
                                Fig10a=Tfig;
                                Timefig=[Timefig Tfig];
                            end
                        end
                        if app.DeltaFluidFieldCheckBox.Value

                            clear Tfig;
                            PlotFields=app.RAWBreakerMeasurementsListBox.Value;
                            N_plots=length(PlotFields);
                            if N_plots>0
                                if TrialCount==1
                                    Tfig.fighandle=figure('Name','Raw DeltaFluid Measurements of Breaker Shapes');
                                else Tfig=Fig10b;
                                end

                                for j=1:length(PlotFields)
                                    TSob=Trial_TS.NonTS.DeltaFluid_field.(PlotFields{j});
                                    Tfig = app.PlotWSContours(Tfig,TSob,N_plots,j,RepstoInclude,PlottingStyle,ReusePlot,N_T);
                                end
                                AllAxes=[AllAxes; Tfig.axes(:)];
                                Fig10b=Tfig;
                                Timefig=[Timefig Tfig];
                            end
                        end

                        if app.ApproximatesurfacecontourCheckBox.Value
                            clear Tfig;
                            PlotFields=app.FusedBreakerMeasurementsListBox.Value;
                            N_plots=length(PlotFields);
                            if N_plots>0
                                if TrialCount==1
                                    Tfig.fighandle=figure('Name','Simplified breaker elevation');
                                else Tfig=Fig11a;
                                end

                                for j=1:length(PlotFields)
                                    TSob=Trial_TS.DeltaFluid_surface_contour_fused.(PlotFields{j});

                                    Tfig = app.PlotTS(Tfig,TSob,N_plots,j,RepstoInclude,PlottingStyle,ReusePlot,N_T);
                                end
                                AllAxes=[AllAxes; Tfig.axes(:)];
                                Fig11a=Tfig;
                                Timefig=[Timefig Tfig];
                            end
                        end
                        if app.DeltaFluidFieldCheckBox_2.Value
                            %% DeltaFluid-Fused

                            clear Tfig;
                            PlotFields=app.FusedBreakerMeasurementsListBox.Value;
                            N_plots=length(PlotFields);
                            if N_plots>0
                                if TrialCount==1
                                    Tfig.fighandle=figure('Name','Fused Measurements of Breaker Shapes');
                                else Tfig=Fig11b;
                                end

                                for j=1:length(PlotFields)
                                    TSob=Trial_TS.NonTS.DeltaFluid_field_fused.(PlotFields{j});

                                    Tfig = app.PlotWSContours(Tfig,TSob,N_plots,j,RepstoInclude,PlottingStyle,ReusePlot,N_T);
                                end
                                AllAxes=[AllAxes; Tfig.axes(:)];
                                Fig11b=Tfig;
                                Timefig=[Timefig Tfig];
                            end
                        end

                        %% ROS Data
                        clear Tfig;
                        PlotFields=app.ROSCommandsListBox.Value;
                        N_plots=length(PlotFields);
                        if N_plots>0
                            if TrialCount==1
                                Tfig.fighandle=figure('Name','ROS Commands');
                            else Tfig=Fig12;
                            end

                            for j=1:length(PlotFields)
                                TSob=Trial_TS.ROSCommands.(PlotFields{j});

                                Tfig = app.PlotTS(Tfig,TSob,N_plots,j,RepstoInclude,PlottingStyle,ReusePlot,N_T);
                            end
                            AllAxes=[AllAxes; Tfig.axes(:)];
                            Fig12=Tfig;
                            Timefig=[Timefig Tfig];
                        end


                        %% Ground Contact
                        clear Tfig;
                        PlotFields=app.GroundContactListBox.Value;
                        N_plots=length(PlotFields);
                        if N_plots>0
                            if TrialCount==1
                                Tfig.fighandle=figure('Name','Ground Contact');
                            else Tfig=Fig13;
                            end

                            for j=1:length(PlotFields)
                                TSob=Trial_TS.GroundContact.(PlotFields{j});

                                Tfig = app.PlotTS(Tfig,TSob,N_plots,j,RepstoInclude,PlottingStyle,ReusePlot,N_T);
                            end
                            AllAxes=[AllAxes; Tfig.axes(:)];
                            Fig13=Tfig;
                            Timefig=[Timefig Tfig];
                        end

                        %% Body-fixed velocities
                        clear Tfig;
                        PlotFields=app.VelocityBodyFixedListBox.Value;
                        N_plots=length(PlotFields);
                        if N_plots>0
                            if TrialCount==1
                                Tfig.fighandle=figure('Name','Body-Fixed Velocity Components');
                            else Tfig=Fig14;
                            end

                            for j=1:length(PlotFields)
                                TSob=Trial_TS.Body_UVW.(PlotFields{j});

                                Tfig = app.PlotTS(Tfig,TSob,N_plots,j,RepstoInclude,PlottingStyle,ReusePlot,N_T);
                            end
                            AllAxes=[AllAxes; Tfig.axes(:)];
                            Fig14=Tfig;
                            Timefig=[Timefig Tfig];
                        end

                        try
                            linkaxes(AllAxes(:),'x');
                            N_ax=length(AllAxes);
                            for n_ax=1:N_ax
                                AllAxes(n_ax).YLabel.Interpreter='none';
                                AllAxes(n_ax).Title.Interpreter='none';
                            end
                        catch
                        end
                        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                        if isfield(Trial_TS,'Position');
                            if TrialCount==1
                                Tempfig=app.Plot3DHWB;
                            else
                                figure(TrajFig.fighandle);
                            end

                            %                 count=1;
                            EvtTimes=Trial_TS.Info.Repliction_times;


                            try
                                Xob=Trial_TS.Position_Gapfilled.X;
                                Yob=Trial_TS.Position_Gapfilled.Y;
                                Zob=Trial_TS.Position_Gapfilled.Z;
                                Yawob=Trial_TS.Orientation_Gapfilled.Yaw;
                                Pob=Trial_TS.Orientation_Gapfilled.Pitch;
                                Rob=Trial_TS.Orientation_Gapfilled.Roll;
                            catch
                                Xob=Trial_TS.Position.X;
                                Yob=Trial_TS.Position.Y;
                                Zob=Trial_TS.Position.Z;
                                Yawob=Trial_TS.Orientation.Yaw;
                                Pob=Trial_TS.Orientation.Pitch;
                                Rob=Trial_TS.Orientation.Roll;
                            end
                            for n=RepstoInclude
                                if or(tempcount>1,N_T>1)
                                    hold on
                                end

                                X.evt(tempcount)=getsampleusingtime(Xob,EvtTimes(n)-app.PreTime,EvtTimes(n)+app.PostTime);
                                Y.evt(tempcount)=getsampleusingtime(Yob,EvtTimes(n)-app.PreTime,EvtTimes(n)+app.PostTime);
                                Z.evt(tempcount)=getsampleusingtime(Zob,EvtTimes(n)-app.PreTime,EvtTimes(n)+app.PostTime);
                                P.evt(tempcount)=getsampleusingtime(Pob,EvtTimes(n)-app.PreTime,EvtTimes(n)+app.PostTime);
                                Yaw.evt(tempcount)=getsampleusingtime(Yawob,EvtTimes(n)-app.PreTime,EvtTimes(n)+app.PostTime);
                                R.evt(tempcount)=getsampleusingtime(Rob,EvtTimes(n)-app.PreTime,EvtTimes(n)+app.PostTime);

                                Dirx = 1000*cosd(Yaw.evt(tempcount).Data).*cosd(-P.evt(tempcount).Data);
                                Diry = 1000*sind(Yaw.evt(tempcount).Data).*cosd(-P.evt(tempcount).Data);
                                Dirz = 1000*sind(-P.evt(tempcount).Data);

                                ltemp(tempcount)=plot3(X.evt(tempcount).Data,Y.evt(tempcount).Data,Z.evt(tempcount).Data,'linewidth',1.5);

                                ltemp(tempcount).DisplayName=[Trial_TS.Info.RunID ' - Subtrial ' num2str(n)];
                                ltemp(tempcount).DataTipTemplate.DataTipRows(end+1) = dataTipTextRow('Trace',repmat({ltemp(tempcount).DisplayName},size(ltemp(tempcount).XData)));

                                ds=30;
                                ldir(tempcount)=quiver3(gca,X.evt(tempcount).Data(1:ds:end),Y.evt(tempcount).Data(1:ds:end),Z.evt(tempcount).Data(1:ds:end),Dirx(1:ds:end),Diry(1:ds:end),Dirz(1:ds:end),0,'Color',ltemp(tempcount).Color*0.6);

                                TrajFig.leg=legend('-dynamiclegend');

                                tempcount=tempcount+1;

                            end
                            hold off
                            legend(ltemp(:));
                            TrajFig.fighandle=Tempfig;
                            TrajFig.axes=[];
                            TrajFig.Sig=[];

                            TrajFig.fighandle.Color='w';
                            view(3)
                            Timefig=[Timefig TrajFig];
                        end
                        TrialCount=TrialCount+1;
                    end
                    IncludedReps{N_T}=RepstoInclude;
                end


                %                 if app.AnimateCollisionStateCheckBox.Value
                %
                %                     app.AnimationWindow=AnimateMQS(app,AllAxes,IncludedReps,N_trials,PlottedReps,PlottingStyle);
                %                     AnimFig.fighandle=app.AnimationWindow.UIFigure;
                %                     AnimFig.axes=app.AnimationWindow.UIAxes;
                %                     AnimFig.Sig=[];
                %                     AnimFig.leg=[];
                %                     Timefig=[Timefig AnimFig];
                %                 end
                app.Timefig=Timefig;
            else
                msgbox('You must select at least one sub-trial / replication for plotting.')
            end


        end

        % Button pushed function: CSVExportButton
        function CSVExportButtonPushed(app, event)
            % This callback exports the selected subset of sub-trials and
            % signals to a tab-delimited TXT file.

            PlottedReps=app.SelectSubTrialsListBox.Value;

            if(~isempty(PlottedReps))
                Trial_TS_mult=app.TrialDataMult;
                N_Trials=length(Trial_TS_mult);


                [fname, fpath]=uiputfile('*.txt','Specify Filename for Export. The run name and subtrial numbers will be automatically appended.',[app.FilePath '\' 'NAME_Export.txt']);
                if fname~=0;
                    fname_base=fname(1:end-4);
                    InterpOption=questdlg(sprintf('Resample each sub-trial to use a common time vector for each sub-trial (relative to model release)? \n Recommended if comparing signals on a sample-to-sample basis, but may smooth out high-frequency fluctuations.'),'Resample?','Yes','No','Yes');
                    switch InterpOption
                        case 'Yes'
                            Interp=1;
                        case 'No'
                            Interp=0;
                    end
                    for N_T=1:N_Trials
                        clearvars -except app fname* N_T* fpath PlottedReps Trial_TS* PlottedReps InterpOption
                        Trial_TS=Trial_TS_mult(N_T);
                        RunID=Trial_TS.Info.RunID;
                        plottedReps_curr=PlottedReps(contains(PlottedReps,RunID));
                        RepstoInclude=[];
                        for j=1:length(plottedReps_curr)
                            temp=plottedReps_curr{j};
                            breaks=strfind(temp,';');
                            breaksdash=strfind(temp,'-');
                            TrialReps{j}=temp(1:breaks-1);
                            RepstoInclude(j)=str2double(temp(breaksdash+1:breaks-1));
                        end
                        RepstoInclude=sort(RepstoInclude);
                        %                 N_reps=length(RepstoInclude);
                        %
                        %                 N_evts=Trial_TS.Info.N_replications;
                        EvtTimes=Trial_TS.Info.Repliction_times;

                        try  TSonly=rmfield(Trial_TS,'NonTS');
                        catch
                            TSonly=Trial_TS;
                        end
                        TSonly=rmfield(TSonly,'Info');
                        Datatypes=fieldnames(TSonly);


                        for n_rep=RepstoInclude

                            for n_d=1:length(Datatypes)
                                signallist=fieldnames(Trial_TS.(Datatypes{n_d}));
                                for n_s=1:length(signallist)
                                    switch InterpOption
                                        case 'Yes'
                                            Sub_TS.(Datatypes{n_d}).(signallist{n_s})=resample(Trial_TS.(Datatypes{n_d}).(signallist{n_s}),[EvtTimes(n_rep)-app.PreTime:0.01:EvtTimes(n_rep)+app.PostTime]);
                                        case 'No'
                                            Sub_TS.(Datatypes{n_d}).(signallist{n_s})=getsampleusingtime(Trial_TS.(Datatypes{n_d}).(signallist{n_s}),EvtTimes(n_rep)-app.PreTime,EvtTimes(n_rep)+app.PostTime);
                                    end
                                end
                            end
                            fid=fopen([fpath fname_base '_' RunID '_REP' num2str(n_rep) '.txt'],'w');
                            datablock=[];
                            try
                                t_common=Sub_TS.ManeuveringInputs.Thrust.Time;
                            catch
                                t_common=Sub_TS.WaveGauges.WaveGauge1.Time;
                            end

                            t_common0=t_common-EvtTimes(n_rep);

                            datablock(:,1)=t_common0;
                            units{1}='Seconds';
                            Printedname{1}='Time after model release';

                            datablock(:,2)=t_common;
                            units{2}='Seconds';
                            Printedname{2}='Absolute Time';

                            LocationsX{1}='X (mm)';
                            LocationsY{1}='Y (mm)';



                            count=3;
                            for n_d=1:length(Datatypes)

                                signallist=fieldnames(Trial_TS.(Datatypes{n_d}));

                                for n_s=1:length(signallist)
                                    Printedname{count}=[Datatypes{n_d} ' - ' signallist{n_s}];
                                    tsresample=resample(Sub_TS.(Datatypes{n_d}).(signallist{n_s}),t_common,'linear');
                                    datablock(:,count)=tsresample.Data;
                                    units{count}=tsresample.DataInfo.Units;
                                    try
                                        LocationsX{count}=Trial_TS.(Datatypes{n_d}).(signallist{n_s}).UserData.LocationInfo.X;

                                    catch
                                        LocationsX{count}=' ';
                                    end
                                    try
                                        LocationsY{count}=Trial_TS.(Datatypes{n_d}).(signallist{n_s}).UserData.LocationInfo.Y;
                                    catch
                                        LocationsY{count}=' ';
                                    end
                                    count=count+1;
                                end
                            end
                            for n_c=1:count-1
                                fprintf(fid,'%s \t',Printedname{n_c});
                            end
                            fprintf(fid,'\n');

                            for n_c=1:count-1
                                fprintf(fid,'%s \t',num2str(LocationsX{n_c}));
                            end
                            fprintf(fid,'\n');

                            for n_c=1:count-1
                                fprintf(fid,'%s \t',num2str(LocationsY{n_c}));
                            end
                            fprintf(fid,'\n');


                            for n_c=1:count-1
                                fprintf(fid,'%s \t',['[' units{n_c} ']']);
                            end
                            fprintf(fid,'\n');

                            n_channels=count-1;
                            fprintf(fid,[repmat('%f \t ',1,n_channels-1) '%f \n'],datablock');
                            fclose(fid);
                        end
                        if ~isempty(RepstoInclude)
                            SigTable=app.CreateSigTable(N_T);
                            writetable(SigTable,[fpath fname_base '_' RunID '_SensorList.txt'],'Delimiter','\t');
                        end
                    end



                end
            else
                msgbox('You must select at least one sub-trial.')
            end
        end

        % Button pushed function: PlayVideosButton
        function PlayVideosButtonPushed(app, event)
            MovieDatabaseMQS=app.MovieDataBaseMQS.MovieDatabaseMQS;
            Fnames=app.FileLoadedName;
            N_Trials=length(Fnames);
            try
                close(app.Vidfig(:));
            catch
            end
            for N_T=1:N_Trials
                clear idx* Source Title Link
                Fname=Fnames{N_T};
                Trial_TS=app.TrialDataMult(N_T);

                try

                    Prefix_ind=findstr(Trial_TS.Info.Trial_Name,'MT');
                    Prefix='MT';
                    if isempty(Prefix_ind)
                        Prefix_ind=findstr(Trial_TS.Info.Trial_Name,'VT');
                        Prefix='VT';
                    end
                    RunID=Trial_TS.Info.Trial_Name(Prefix_ind:Prefix_ind+4);
                    RunNo=RunID(3:end);

                    idx_all=find(contains(MovieDatabaseMQS.title,[Prefix RunNo]));

                    for n=1:length(idx_all)
                        Temptitle=MovieDatabaseMQS.title{idx_all(n)};
                        Colonind=strfind(Temptitle,':');
                        Source{n}=MovieDatabaseMQS.description{idx_all(n)};
                        Title{n}=Temptitle;
                        Link{n}=MovieDatabaseMQS.streamingURL{idx_all(n)};
                    end


                    mastertable=table(Title',Source',Link');
                    VidNamesOnly=table(Title',Source');

                    app.Vidfig(N_T)=uifigure('Name',['Video Catalog for' Fname '; Click on a cell to open in internet browser']);
                    VidTable=uitable(app.Vidfig(N_T),'Data',VidNamesOnly,'ColumnName',{'Video Titles','Description'});
                    VidTable.Units='normalized'; VidTable.Position=[0.1 0.1 0.8 0.8];
                    app.Vidfig(N_T).Position(3)=765;
                    VidTable.ColumnWidth={250, 400};

                    VidTable.CellSelectionCallback={@app.OpenVid, mastertable};


                catch

                    Title={'No Videos Available'};
                    Source={'-'}; Link={'-'};
                    VidNamesOnly=table(Title',Source');
                    app.Vidfig=uifigure('Name',['Video Catalog for' Fname]);
                    VidTable=uitable(app.Vidfig,'Data',VidNamesOnly,'ColumnName',{'Video Titles','Source/View'});
                    VidTable.Units='normalized'; VidTable.Position=[0.1 0.1 0.8 0.8];
                    VidTable.ColumnWidth={250, 400};
                end
            end
        end

        % Button pushed function: WaveSensorLocationsButton
        function WaveSensorLocationsButtonPushed(app, event)
            Tempfig=app.Plot3DHWB;
            Trial_TS=app.TrialData;
            view(3);
            ylim([-11000 -5000]);
            ax=findobj(Tempfig,'type','axes');
            Datatypes=fieldnames(Trial_TS);
            idxInfo=find(contains(Datatypes,'Info'));
            Datatypes(idxInfo)=[];


            for n_D=1:length(Datatypes)
                if(~contains(Datatypes{n_D},'fused'))
                    sigtypes=fieldnames(Trial_TS.(Datatypes{n_D}));
                    for n_s=1:length(sigtypes)
                        if(~contains(sigtypes{n_s},'fused'))
                            try
                                Temp=Trial_TS.(Datatypes{n_D}).(sigtypes{n_s});
                                X=Temp.UserData.LocationInfo.X;
                                Y=Temp.UserData.LocationInfo.Y;
                                hold on
                                p1=plot3(ax,X,Y,0,'o');
                                p1.MarkerFaceColor=p1.Color;
                                hold off
                                text(ax,X,Y,0.5,Temp.Name,'Rotation',60,'Interpreter','none','VerticalAlignment','middle',"HorizontalAlignment","left");
                            catch
                            end
                        end
                    end
                end
            end


        end

        % Button pushed function: ListofSignalsButton
        function ListofSignalsButtonPushed(app, event)
            % Print list of all signals and their descriptions into a
            % listbox;
            try
                close(app.SigListFig)
            catch
            end
            app.SigListFig=uifigure();
            app.SigListFig.Position=[600 200 1000 800];
            %             SigList=uitextarea(app.SigListFig);
            SigList=uitable(app.SigListFig);
            %             SigList.BackgroundColor = [0.9412 0.9412 0.9412];
            SigList.Position = [50 50 900 700];

            SigTable=app.CreateSigTable(0);
            SigList.Data=SigTable;
            SigList.ColumnSortable=true;
            SigList.ColumnEditable=[false false false false false false];
            SigList.Position(3)=900;
            SigList.ColumnName={'Signal Type','Signal Name','Units','Sample Rate','Bit Depth','Description'};
            SigList.ColumnWidth={150,150,75,75,75,350};

        end

        % Value changed function: SecondsprereleaseSpinner
        function SecondsprereleaseSpinnerValueChanged(app, event)
            value = app.SecondsprereleaseSpinner.Value;
            app.PreTime=value;
        end

        % Value changed function: SecondspostreleaseSpinner
        function SecondspostreleaseSpinnerValueChanged(app, event)
            value = app.SecondspostreleaseSpinner.Value;
            app.PostTime=value;
        end

        % Button pushed function: ModelMassPropertiesButton
        function ModelMassPropertiesButtonPushed(app, event)
            try
                try
                    close(app.MassPropFig);
                catch
                end
                app.MassPropFig=uifigure;
                app.MassPropFig.Position=[200 125 600 850];
                MassDisplayTable=uitable(app.MassPropFig);
                Image_2 = uiimage(app.MassPropFig);
                Image_2.Position = [50 450 500 400];
                Image_2.ImageSource = 'CoordinateSystem_MQS.png';

                MassDisplayTable.Data=app.MassTable.Data;
                MassDisplayTable.ColumnName=app.MassTable.ColNames;
                MassDisplayTable.RowName=app.MassTable.RowNames;
                MassDisplayTable.Position=[150 50 300 350];
            catch
                msgbox('Mass data unavailable for this trial')
            end
        end

        % Button pushed function: PlotEnsembleAverageButton
        function PlotEnsembleAverageButtonPushed(app, event)
            try
                tempfighandles=[app.Ensemblefig(:).fighandle];
                close(tempfighandles);
            catch
            end
            AllAxes=[];

            PlottedReps=app.SelectSubTrialsListBox.Value;
            EnsFig=[];
            if(~isempty(PlottedReps))

                Trial_TS_mult=app.TrialDataMult;
                N_trials=length(Trial_TS_mult);




                for N_T=1:N_trials
                    RepstoInclude=[];
                    RunID=Trial_TS_mult(N_T).Info.RunID;
                    plottedReps_curr=PlottedReps(contains(PlottedReps,RunID));
                    for j=1:length(plottedReps_curr)
                        temp=plottedReps_curr{j};
                        breaks=strfind(temp,';');
                        breaksdash=strfind(temp,'-');
                        TrialReps{j}=temp(1:breaks-1);
                        RepstoInclude(j)=str2double(temp(breaksdash+1:breaks-1));
                    end
                    Reps_mult{N_T}=sort(RepstoInclude);
                end


                %% Maneuvering Inputs
                PlotFields=app.LoggedActuationListBox.Value;
                N_plots=length(PlotFields);
                Dtype='ManeuveringInputs';
                FigName='Maneuvering Inputs';
                if N_plots>0
                    Tfig=app.EnsemblePlot(Trial_TS_mult,Dtype,PlotFields,Reps_mult,N_plots,FigName);
                    AllAxes=[AllAxes; Tfig.axes(:)];
                    Fig1=Tfig;
                    EnsFig=[EnsFig Tfig];
                end


                %% MoCap Data - Position
                clear Tfig
                PlotFields=app.PositionXYZListBox.Value;
                N_plots=length(PlotFields);
                Dtype='Position';
                FigName='Position';
                if N_plots>0
                    Tfig=app.EnsemblePlot(Trial_TS_mult,Dtype,PlotFields,Reps_mult,N_plots,FigName);
                    AllAxes=[AllAxes; Tfig.axes(:)];
                    Fig2=Tfig;
                    EnsFig=[EnsFig Tfig];
                end

                %% MoCap Data - Position GapFilled
                clear Tfig
                PlotFields=app.PositionXYZGapFilledListBox.Value;
                N_plots=length(PlotFields);
                Dtype='Position_Gapfilled';
                FigName='Gap-Filled Position';
                if N_plots>0
                    Tfig=app.EnsemblePlot(Trial_TS_mult,Dtype,PlotFields,Reps_mult,N_plots,FigName);
                    AllAxes=[AllAxes; Tfig.axes(:)];
                    Fig3=Tfig;
                    EnsFig=[EnsFig Tfig];
                end

                %% Euler Angles
                clear Tfig
                PlotFields=app.OrientationListBox.Value;
                N_plots=length(PlotFields);
                Dtype='Orientation';
                FigName='Gap-Filled Orientation';
                if N_plots>0
                    Tfig=app.EnsemblePlot(Trial_TS_mult,Dtype,PlotFields,Reps_mult,N_plots,FigName);

                    AllAxes=[AllAxes; Tfig.axes(:)];
                    Fig4=Tfig;
                    EnsFig=[EnsFig Tfig];
                end


                %% Euler Angles - Gap Filled
                clear Tfig
                PlotFields=app.OrientationGapFilledListBox.Value;
                N_plots=length(PlotFields);
                Dtype='Orientation_Gapfilled';
                FigName='Gap-Filled Orientation';
                if N_plots>0
                    Tfig=app.EnsemblePlot(Trial_TS_mult,Dtype,PlotFields,Reps_mult,N_plots,FigName);
                    AllAxes=[AllAxes; Tfig.axes(:)];
                    Fig5=Tfig;
                    EnsFig=[EnsFig Tfig];
                end

                %% IMU-Accelerations
                clear Tfig
                PlotFields=app.AccelerationsListBox.Value;
                N_plots=length(PlotFields);
                Dtype='Accel';
                FigName='Accelerations';
                if N_plots>0
                    Tfig=app.EnsemblePlot(Trial_TS_mult,Dtype,PlotFields,Reps_mult,N_plots,FigName);
                    AllAxes=[AllAxes; Tfig.axes(:)];
                    Fig6=Tfig;
                    EnsFig=[EnsFig Tfig];
                end

                %% IMU-Gyroscope
                clear Tfig
                PlotFields=app.AngularRatesListBox.Value;
                N_plots=length(PlotFields);
                Dtype='AngularRates';
                FigName='Angular Rates';
                if N_plots>0
                    Tfig=app.EnsemblePlot(Trial_TS_mult,Dtype,PlotFields,Reps_mult,N_plots,FigName);
                    AllAxes=[AllAxes; Tfig.axes(:)];
                    Fig7=Tfig;
                    EnsFig=[EnsFig Tfig];
                end

                %% Velocities
                clear Tfig;
                PlotFields=app.VelocityGapFilledListBox.Value;
                N_plots=length(PlotFields);
                Dtype='Velocities_Gapfilled';
                FigName='Model Velocities';
                if N_plots>0
                    Tfig=app.EnsemblePlot(Trial_TS_mult,Dtype,PlotFields,Reps_mult,N_plots,FigName);
                    AllAxes=[AllAxes; Tfig.axes(:)];
                    Fig8=Tfig;
                    EnsFig=[EnsFig Tfig];
                end


                %% Deep Water Acoustics
                clear Tfig;
                PlotFields=app.DeepWaterAcousticsListBox.Value;
                N_plots=length(PlotFields);
                Dtype='WaveGauges';
                FigName='Deep Water Acoustic Wave Gauges';
                if N_plots>0
                    Tfig=app.EnsemblePlot(Trial_TS_mult,Dtype,PlotFields,Reps_mult,N_plots,FigName);
                    AllAxes=[AllAxes; Tfig.axes(:)];
                    Fig9=Tfig;
                    EnsFig=[EnsFig Tfig];
                end

                %% DeltaFluid-RAW
                % Determine which (if either) of the raw breaker sensor
                % outputs to use.
                if and(app.AcousticGaugesCheckBox.Value,Trial_TS_mult(1).Info.IncludedData.NRLSenix==1)
                    %% Deep Water Acoustics
                    clear Tfig;
                    PlotFields=app.RAWBreakerMeasurementsListBox.Value;
                    N_plots=length(PlotFields);
                    Dtype='NRLAcoustics';
                    FigName='Raw Acoustic Measurements of Breakers';
                    if N_plots>0
                        Tfig=app.EnsemblePlot(Trial_TS_mult,Dtype,PlotFields,Reps_mult,N_plots,FigName);
                        AllAxes=[AllAxes; Tfig.axes(:)];
                        Fig10a=Tfig;
                        EnsFig=[EnsFig Tfig];
                    end
                end


                if app.ApproximatesurfacecontourCheckBox.Value
                    clear Tfig;
                    PlotFields=app.FusedBreakerMeasurementsListBox.Value;
                    N_plots=length(PlotFields);
                    Dtype='DeltaFluid_surface_contour_fused';
                    FigName='Approximate water surface contour (fused)';
                    if N_plots>0
                        Tfig=app.EnsemblePlot(Trial_TS_mult,Dtype,PlotFields,Reps_mult,N_plots,FigName);
                        AllAxes=[AllAxes; Tfig.axes(:)];
                        Fig11a=Tfig;
                        EnsFig=[EnsFig Tfig];
                    end
                end


                %% ROS Data
                clear Tfig;
                PlotFields=app.ROSCommandsListBox.Value;
                N_plots=length(PlotFields);

                Dtype='ROSCommands';
                FigName='ROS logged commands';
                if N_plots>0
                    Tfig=app.EnsemblePlot(Trial_TS_mult,Dtype,PlotFields,Reps_mult,N_plots,FigName);
                    AllAxes=[AllAxes; Tfig.axes(:)];
                    Fig12=Tfig;
                    EnsFig=[EnsFig Tfig];
                end

                try
                    linkaxes(AllAxes(:),'x');
                    N_ax=length(AllAxes);
                    for n_ax=1:N_ax
                        AllAxes(n_ax).YLabel.Interpreter='none';
                        AllAxes(n_ax).Title.Interpreter='none';
                    end
                catch
                end
                app.Ensemblefig=EnsFig;
            else
                msgbox('Select at least one sub-trial')
            end
        end

        % Button pushed function: FFTButton
        function FFTButtonPushed(app, event)
            try
                tempfighandles=[app.FFTfig(:).fighandle];
                close(tempfighandles);
            catch
            end

            AllAxes=[];

            PlottedReps=app.SelectSubTrialsListBox.Value;

            if(~isempty(PlottedReps))

                Trial_TS_mult=app.TrialDataMult;
                N_trials=length(Trial_TS_mult);


                for N_T=1:N_trials
                    RepstoInclude=[];
                    RunID=Trial_TS_mult(N_T).Info.RunID;
                    plottedReps_curr=PlottedReps(contains(PlottedReps,RunID));
                    for j=1:length(plottedReps_curr)
                        temp=plottedReps_curr{j};
                        breaks=strfind(temp,';');
                        breaksdash=strfind(temp,'-');
                        TrialReps{j}=temp(1:breaks-1);
                        RepstoInclude(j)=str2double(temp(breaksdash+1:breaks-1));
                    end
                    Reps_mult{N_T}=sort(RepstoInclude);
                end


                %% Maneuvering Inputs
                PlotFields=app.LoggedActuationListBox.Value;
                N_plots=length(PlotFields);
                Dtype='ManeuveringInputs';
                FigName='Maneuvering Inputs';
                if N_plots>0
                    Tfig=app.FFTPlot(Trial_TS_mult,Dtype,PlotFields,Reps_mult,N_plots,FigName);
                    AllAxes=[AllAxes; Tfig.axes(:)];
                    FFTfig(1)=Tfig;

                end


                %% MoCap Data - Position
                clear Tfig
                PlotFields=app.PositionXYZListBox.Value;
                N_plots=length(PlotFields);
                Dtype='Position';
                FigName='Position';
                if N_plots>0
                    Tfig=app.FFTPlot(Trial_TS_mult,Dtype,PlotFields,Reps_mult,N_plots,FigName);
                    AllAxes=[AllAxes; Tfig.axes(:)];
                    FFTfig(2)=Tfig;
                end

                %% MoCap Data - Position GapFilled
                clear Tfig
                PlotFields=app.PositionXYZGapFilledListBox.Value;
                N_plots=length(PlotFields);
                Dtype='Position_Gapfilled';
                FigName='Gap-Filled Position';
                if N_plots>0
                    Tfig=app.FFTPlot(Trial_TS_mult,Dtype,PlotFields,Reps_mult,N_plots,FigName);
                    AllAxes=[AllAxes; Tfig.axes(:)];
                    FFTfig(3)=Tfig;
                end

                %% Euler Angles
                clear Tfig
                PlotFields=app.OrientationListBox.Value;
                N_plots=length(PlotFields);
                Dtype='Orientation';
                FigName='Gap-Filled Orientation';
                if N_plots>0
                    Tfig=app.FFTPlot(Trial_TS_mult,Dtype,PlotFields,Reps_mult,N_plots,FigName);

                    AllAxes=[AllAxes; Tfig.axes(:)];
                    FFTfig(4)=Tfig;
                end


                %% Euler Angles - Gap Filled
                clear Tfig
                PlotFields=app.OrientationGapFilledListBox.Value;
                N_plots=length(PlotFields);
                Dtype='Orientation_Gapfilled';
                FigName='Gap-Filled Orientation';
                if N_plots>0
                    Tfig=app.FFTPlot(Trial_TS_mult,Dtype,PlotFields,Reps_mult,N_plots,FigName);
                    AllAxes=[AllAxes; Tfig.axes(:)];
                    FFTfig(5)=Tfig;
                end

                %% IMU-Accelerations
                clear Tfig
                PlotFields=app.AccelerationsListBox.Value;
                N_plots=length(PlotFields);
                Dtype='Accel';
                FigName='Accelerations';
                if N_plots>0
                    Tfig=app.FFTPlot(Trial_TS_mult,Dtype,PlotFields,Reps_mult,N_plots,FigName);
                    AllAxes=[AllAxes; Tfig.axes(:)];
                    FFTfig(6)=Tfig;
                end

                %% IMU-Gyroscope
                clear Tfig
                PlotFields=app.AngularRatesListBox.Value;
                N_plots=length(PlotFields);
                Dtype='AngularRates';
                FigName='Angular Rates';
                if N_plots>0
                    Tfig=app.FFTPlot(Trial_TS_mult,Dtype,PlotFields,Reps_mult,N_plots,FigName);
                    AllAxes=[AllAxes; Tfig.axes(:)];
                    FFTfig(7)=Tfig;
                end

                %% Velocities
                clear Tfig;
                PlotFields=app.VelocityGapFilledListBox.Value;
                N_plots=length(PlotFields);
                Dtype='Velocities_Gapfilled';
                FigName='Model Velocities';
                if N_plots>0
                    Tfig=app.FFTPlot(Trial_TS_mult,Dtype,PlotFields,Reps_mult,N_plots,FigName);
                    AllAxes=[AllAxes; Tfig.axes(:)];
                    FFTfig(8)=Tfig;
                end


                %% Deep Water Acoustics
                clear Tfig;
                PlotFields=app.DeepWaterAcousticsListBox.Value;
                N_plots=length(PlotFields);
                Dtype='WaveGauges';
                FigName='Deep Water Acoustic Wave Gauges';
                if N_plots>0
                    Tfig=app.FFTPlot(Trial_TS_mult,Dtype,PlotFields,Reps_mult,N_plots,FigName);
                    AllAxes=[AllAxes; Tfig.axes(:)];
                    FFTfig(9)=Tfig;
                end

                %% DeltaFluid-RAW
                % Determine which (if either) of the raw breaker sensor
                % outputs to use.
                if and(app.AcousticGaugesCheckBox.Value,Trial_TS_mult(1).Info.IncludedData.NRLSenix==1)
                    %% Deep Water Acoustics
                    clear Tfig;
                    PlotFields=app.RAWBreakerMeasurementsListBox.Value;
                    N_plots=length(PlotFields);
                    Dtype='NRLAcoustics';
                    FigName='Raw Acoustic Measurements of Breakers';
                    if N_plots>0
                        Tfig=app.FFTPlot(Trial_TS_mult,Dtype,PlotFields,Reps_mult,N_plots,FigName);
                        AllAxes=[AllAxes; Tfig.axes(:)];
                        FFTfig(10)=Tfig;
                    end
                end


                if app.ApproximatesurfacecontourCheckBox.Value
                    clear Tfig;
                    PlotFields=app.FusedBreakerMeasurementsListBox.Value;
                    N_plots=length(PlotFields);
                    Dtype='DeltaFluid_surface_contour_fused';
                    FigName='Approximate water surface contour (fused)';
                    if N_plots>0
                        Tfig=app.FFTPlot(Trial_TS_mult,Dtype,PlotFields,Reps_mult,N_plots,FigName);
                        AllAxes=[AllAxes; Tfig.axes(:)];
                        FFTfig(11)=Tfig;
                    end
                end


                %% ROS Data
                clear Tfig;
                PlotFields=app.ROSCommandsListBox.Value;
                N_plots=length(PlotFields);

                Dtype='ROSCommands';
                FigName='ROS logged commands';
                if N_plots>0
                    Tfig=app.FFTPlot(Trial_TS_mult,Dtype,PlotFields,Reps_mult,N_plots,FigName);
                    AllAxes=[AllAxes; Tfig.axes(:)];
                    FFTfig(12)=Tfig;
                end

                try
                    linkaxes(AllAxes(:),'x');
                    N_ax=length(AllAxes);
                    for n_ax=1:N_ax
                        AllAxes(n_ax).YLabel.Interpreter='none';
                        AllAxes(n_ax).Title.Interpreter='none';
                    end
                catch
                end
                app.FFTfig=FFTfig;
            else
                msgbox('Select at least one sub-trial')
            end
        end

        % Button pushed function: CloseAllFiguresButton
        function CloseAllFiguresButtonPushed(app, event)
            close all;
            try
                delete(app.AnimationWindow)
            catch ME
            end
        end

        % Button pushed function: OpenTrialClusterGroupButton
        function OpenTrialClusterGroupButtonPushed(app, event)
            [fname, fpath]=uigetfile('PH2*.mat','MultiSelect','off');
            if fname~=0;
                load([fpath fname]);

                RunSet_old=RunSet;
                clearvars RunSet;
                ff=fieldnames(RunSet_old);
                for n=1:length(ff)
                    RunSet.([ff{n} '_Consolidated_TS'])=RunSet_old.(ff{n});
                end

                [fpathParent, ~]=fileparts(fpath);
                [fpathParent2, ~]=fileparts(fpathParent);

                app.GroupLoaded=1;
                app.GroupPath=[fpathParent2 '\'];
                app.GroupSet=RunSet;

                OpenSingleTrialButtonPushed(app);
            end
        end

        % Button pushed function: PlotCustomXvsYButton
        function PlotCustomXvsYButtonPushed(app, event)
            [datablock,signalnames,units]=app.GetInterpolatedDataBlock();

            xsrc=listdlg('PromptString','Select one independent (X) variable.','ListString',signalnames,'SelectionMode','single');
            ysrc=listdlg('PromptString','Select dependent (Y) variable(s).','ListString',signalnames);

            N_y=length(ysrc);
            N_t=size(datablock,3);

            X=squeeze(datablock(:,xsrc,:));
                     fwait=waitbar(0,'Plotting');
            for n=1:N_y
                Y=squeeze(datablock(:,ysrc(n),:));
                COVarray=app.calculateCovarianceTimeData(X,Y);

                XX=mean(X,2);
                YY=mean(Y,2);
                labels.X=signalnames{xsrc};
                labels.Y=signalnames{ysrc(n)};

                unitsdef.X=units{xsrc};
                unitsdef.Y=units{ysrc(n)};
                labels.N=N_t;

                [ff]=app.Plot_XY_Ensemble(XX,YY,COVarray,labels,unitsdef);
                
         waitbar(n/N_y,fwait);
            end
            close(fwait);
            % save('TestDataBlock.mat','datablock','signalnames','units')

        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIWaveBasinDataViewerUIFigure and hide until all components are created
            app.UIWaveBasinDataViewerUIFigure = uifigure('Visible', 'off');
            app.UIWaveBasinDataViewerUIFigure.Color = [0.902 0.902 0.902];
            app.UIWaveBasinDataViewerUIFigure.Position = [100 100 1074 748];
            app.UIWaveBasinDataViewerUIFigure.Name = 'UI Wave Basin DataViewer';
            app.UIWaveBasinDataViewerUIFigure.Icon = 'splash.png';

            % Create OpenSingleTrialButton
            app.OpenSingleTrialButton = uibutton(app.UIWaveBasinDataViewerUIFigure, 'push');
            app.OpenSingleTrialButton.ButtonPushedFcn = createCallbackFcn(app, @OpenSingleTrialButtonPushed, true);
            app.OpenSingleTrialButton.FontWeight = 'bold';
            app.OpenSingleTrialButton.Tooltip = {'Load a new .MAT data file for a single data collection.'};
            app.OpenSingleTrialButton.Position = [33 617 192 32];
            app.OpenSingleTrialButton.Text = 'Open Single Trial';

            % Create RunParametersMetadataTextAreaLabel
            app.RunParametersMetadataTextAreaLabel = uilabel(app.UIWaveBasinDataViewerUIFigure);
            app.RunParametersMetadataTextAreaLabel.HorizontalAlignment = 'center';
            app.RunParametersMetadataTextAreaLabel.FontWeight = 'bold';
            app.RunParametersMetadataTextAreaLabel.Position = [468 690 237 22];
            app.RunParametersMetadataTextAreaLabel.Text = 'Run Parameters & Metadata';

            % Create PlotCustomizationLabel
            app.PlotCustomizationLabel = uilabel(app.UIWaveBasinDataViewerUIFigure);
            app.PlotCustomizationLabel.HorizontalAlignment = 'center';
            app.PlotCustomizationLabel.FontSize = 14;
            app.PlotCustomizationLabel.FontWeight = 'bold';
            app.PlotCustomizationLabel.Position = [422 513 232 22];
            app.PlotCustomizationLabel.Text = 'Plot Customization';

            % Create LoggedActuationLabel
            app.LoggedActuationLabel = uilabel(app.UIWaveBasinDataViewerUIFigure);
            app.LoggedActuationLabel.HorizontalAlignment = 'center';
            app.LoggedActuationLabel.FontWeight = 'bold';
            app.LoggedActuationLabel.Position = [431 449 83 28];
            app.LoggedActuationLabel.Text = {'Logged '; 'Actuation'};

            % Create LoggedActuationListBox
            app.LoggedActuationListBox = uilistbox(app.UIWaveBasinDataViewerUIFigure);
            app.LoggedActuationListBox.Items = {};
            app.LoggedActuationListBox.Tooltip = {'MQS inputs/actuations, measured using on-board datalogging. '};
            app.LoggedActuationListBox.Position = [418 203 110 241];
            app.LoggedActuationListBox.Value = {};

            % Create PositionXYZLabel
            app.PositionXYZLabel = uilabel(app.UIWaveBasinDataViewerUIFigure);
            app.PositionXYZLabel.HorizontalAlignment = 'center';
            app.PositionXYZLabel.FontWeight = 'bold';
            app.PositionXYZLabel.Position = [42 443 56 28];
            app.PositionXYZLabel.Text = {'Position '; '(X-Y-Z)'};

            % Create PositionXYZListBox
            app.PositionXYZListBox = uilistbox(app.UIWaveBasinDataViewerUIFigure);
            app.PositionXYZListBox.Items = {};
            app.PositionXYZListBox.Tooltip = {'Position of MQS datum in global coordinate system. RAW output from MoCap.'};
            app.PositionXYZListBox.Position = [34 363 73 81];
            app.PositionXYZListBox.Value = {};

            % Create VelocityGapFilledListBoxLabel
            app.VelocityGapFilledListBoxLabel = uilabel(app.UIWaveBasinDataViewerUIFigure);
            app.VelocityGapFilledListBoxLabel.HorizontalAlignment = 'center';
            app.VelocityGapFilledListBoxLabel.FontWeight = 'bold';
            app.VelocityGapFilledListBoxLabel.Position = [229 289 72 28];
            app.VelocityGapFilledListBoxLabel.Text = {'Velocity'; '(Gap-Filled)'};

            % Create VelocityGapFilledListBox
            app.VelocityGapFilledListBox = uilistbox(app.UIWaveBasinDataViewerUIFigure);
            app.VelocityGapFilledListBox.Items = {};
            app.VelocityGapFilledListBox.Tooltip = {'Velocities of MQS datum. Measured in global coordinate system. Fused with IMU data to fill gaps and reduce noise.'};
            app.VelocityGapFilledListBox.Position = [230 206 69 81];
            app.VelocityGapFilledListBox.Value = {};

            % Create PlotSelectionButton
            app.PlotSelectionButton = uibutton(app.UIWaveBasinDataViewerUIFigure, 'push');
            app.PlotSelectionButton.ButtonPushedFcn = createCallbackFcn(app, @PlotSelectionButtonPushed, true);
            app.PlotSelectionButton.FontSize = 14;
            app.PlotSelectionButton.FontWeight = 'bold';
            app.PlotSelectionButton.Tooltip = {'Plot all selected signals for all selected sub-trial replications.'};
            app.PlotSelectionButton.Position = [425 116 106 46];
            app.PlotSelectionButton.Text = 'Plot Selection';

            % Create PlottingStyleButtonGroup
            app.PlottingStyleButtonGroup = uibuttongroup(app.UIWaveBasinDataViewerUIFigure);
            app.PlottingStyleButtonGroup.Title = 'Plotting Style';
            app.PlottingStyleButtonGroup.FontWeight = 'bold';
            app.PlottingStyleButtonGroup.Position = [202 21 201 90];

            % Create SubTrialsSequentialT0atstartofrunButton
            app.SubTrialsSequentialT0atstartofrunButton = uiradiobutton(app.PlottingStyleButtonGroup);
            app.SubTrialsSequentialT0atstartofrunButton.Tooltip = {'Data will be plotted against time since beginning of data collection.Repeated sub-trials will be shown sequentially.'};
            app.SubTrialsSequentialT0atstartofrunButton.Text = {'Sub-Trials Sequential'; '(T0 at start of run)'};
            app.SubTrialsSequentialT0atstartofrunButton.Position = [11 40 136 28];
            app.SubTrialsSequentialT0atstartofrunButton.Value = true;

            % Create SubTrialsOverlaidT0atstartofeachsubtrialButton
            app.SubTrialsOverlaidT0atstartofeachsubtrialButton = uiradiobutton(app.PlottingStyleButtonGroup);
            app.SubTrialsOverlaidT0atstartofeachsubtrialButton.Tooltip = {'Data will be plotted against time since the release of the model. Repeated sub-trials will be overlaid onto one another.'};
            app.SubTrialsOverlaidT0atstartofeachsubtrialButton.Text = {'Sub-Trials Overlaid'; '(T0 at start of each sub-trial)'};
            app.SubTrialsOverlaidT0atstartofeachsubtrialButton.Position = [11 6 173 28];

            % Create SelectSubTrialsListBoxLabel
            app.SelectSubTrialsListBoxLabel = uilabel(app.UIWaveBasinDataViewerUIFigure);
            app.SelectSubTrialsListBoxLabel.HorizontalAlignment = 'center';
            app.SelectSubTrialsListBoxLabel.FontWeight = 'bold';
            app.SelectSubTrialsListBoxLabel.Position = [42 161 127 22];
            app.SelectSubTrialsListBoxLabel.Text = 'Select Sub-Trials';

            % Create SelectSubTrialsListBox
            app.SelectSubTrialsListBox = uilistbox(app.UIWaveBasinDataViewerUIFigure);
            app.SelectSubTrialsListBox.Items = {};
            app.SelectSubTrialsListBox.Tooltip = {'Sub-trials (and release trigger times) included in the loaded trial(s). Plots will include only the selected sub-trials.'};
            app.SelectSubTrialsListBox.Position = [34 21 142 141];
            app.SelectSubTrialsListBox.Value = {};

            % Create LoadandReviewTrialsLabel
            app.LoadandReviewTrialsLabel = uilabel(app.UIWaveBasinDataViewerUIFigure);
            app.LoadandReviewTrialsLabel.HorizontalAlignment = 'center';
            app.LoadandReviewTrialsLabel.FontSize = 14;
            app.LoadandReviewTrialsLabel.FontWeight = 'bold';
            app.LoadandReviewTrialsLabel.Position = [1 718 1074 31];
            app.LoadandReviewTrialsLabel.Text = 'Load and Review Trials';

            % Create OrientationListBoxLabel
            app.OrientationListBoxLabel = uilabel(app.UIWaveBasinDataViewerUIFigure);
            app.OrientationListBoxLabel.HorizontalAlignment = 'center';
            app.OrientationListBoxLabel.FontWeight = 'bold';
            app.OrientationListBoxLabel.Position = [114 449 70 22];
            app.OrientationListBoxLabel.Text = 'Orientation';

            % Create OrientationListBox
            app.OrientationListBox = uilistbox(app.UIWaveBasinDataViewerUIFigure);
            app.OrientationListBox.Items = {};
            app.OrientationListBox.Tooltip = {'Euler angles of MQS in Y-P-R convention. Measured in MQS coordinate system. RAW output from MoCap.'};
            app.OrientationListBox.Position = [113 363 73 81];
            app.OrientationListBox.Value = {};

            % Create PositionXYZGapFilledListBoxLabel
            app.PositionXYZGapFilledListBoxLabel = uilabel(app.UIWaveBasinDataViewerUIFigure);
            app.PositionXYZGapFilledListBoxLabel.HorizontalAlignment = 'center';
            app.PositionXYZGapFilledListBoxLabel.FontWeight = 'bold';
            app.PositionXYZGapFilledListBoxLabel.Position = [22 288 95 28];
            app.PositionXYZGapFilledListBoxLabel.Text = {'Position (X-Y-Z)'; '(Gap-Filled)'};

            % Create PositionXYZGapFilledListBox
            app.PositionXYZGapFilledListBox = uilistbox(app.UIWaveBasinDataViewerUIFigure);
            app.PositionXYZGapFilledListBox.Items = {};
            app.PositionXYZGapFilledListBox.Tooltip = {'Position of MQS datum in global coordinate system. Fused with IMU data to fill gaps and reduce noise.'};
            app.PositionXYZGapFilledListBox.Position = [34 205 73 81];
            app.PositionXYZGapFilledListBox.Value = {};

            % Create OrientationGapFilledListBoxLabel
            app.OrientationGapFilledListBoxLabel = uilabel(app.UIWaveBasinDataViewerUIFigure);
            app.OrientationGapFilledListBoxLabel.HorizontalAlignment = 'center';
            app.OrientationGapFilledListBoxLabel.FontWeight = 'bold';
            app.OrientationGapFilledListBoxLabel.Position = [115 288 72 28];
            app.OrientationGapFilledListBoxLabel.Text = {'Orientation'; '(Gap-Filled)'};

            % Create OrientationGapFilledListBox
            app.OrientationGapFilledListBox = uilistbox(app.UIWaveBasinDataViewerUIFigure);
            app.OrientationGapFilledListBox.Items = {};
            app.OrientationGapFilledListBox.Tooltip = {'Euler angles of MQS in Y-P-R convention. Measured in MQS coordinate system. Fused with IMU data to fill gaps and reduce noise.'};
            app.OrientationGapFilledListBox.Position = [113 205 73 81];
            app.OrientationGapFilledListBox.Value = {};

            % Create AccelerationsListBoxLabel
            app.AccelerationsListBoxLabel = uilabel(app.UIWaveBasinDataViewerUIFigure);
            app.AccelerationsListBoxLabel.HorizontalAlignment = 'center';
            app.AccelerationsListBoxLabel.FontWeight = 'bold';
            app.AccelerationsListBoxLabel.Position = [223 450 84 22];
            app.AccelerationsListBoxLabel.Text = 'Accelerations';

            % Create AccelerationsListBox
            app.AccelerationsListBox = uilistbox(app.UIWaveBasinDataViewerUIFigure);
            app.AccelerationsListBox.Items = {};
            app.AccelerationsListBox.Tooltip = {'Accelerations of the MQS, measured at the location of the IMU and reported in MQS coordinate system.'};
            app.AccelerationsListBox.Position = [231 364 69 81];
            app.AccelerationsListBox.Value = {};

            % Create AngularRatesListBoxLabel
            app.AngularRatesListBoxLabel = uilabel(app.UIWaveBasinDataViewerUIFigure);
            app.AngularRatesListBoxLabel.HorizontalAlignment = 'center';
            app.AngularRatesListBoxLabel.FontWeight = 'bold';
            app.AngularRatesListBoxLabel.Position = [317 450 54 28];
            app.AngularRatesListBoxLabel.Text = {'Angular '; 'Rates'};

            % Create AngularRatesListBox
            app.AngularRatesListBox = uilistbox(app.UIWaveBasinDataViewerUIFigure);
            app.AngularRatesListBox.Items = {};
            app.AngularRatesListBox.Tooltip = {'Angular velocities of the MQS, measured at the location of the IMU and reported in MQS coordinate system.'};
            app.AngularRatesListBox.Position = [306 364 69 81];
            app.AngularRatesListBox.Value = {};

            % Create DeepWaterAcousticsLabel
            app.DeepWaterAcousticsLabel = uilabel(app.UIWaveBasinDataViewerUIFigure);
            app.DeepWaterAcousticsLabel.HorizontalAlignment = 'center';
            app.DeepWaterAcousticsLabel.FontWeight = 'bold';
            app.DeepWaterAcousticsLabel.Position = [704 449 75 28];
            app.DeepWaterAcousticsLabel.Text = {'Deep-Water '; 'Acoustics'};

            % Create DeepWaterAcousticsListBox
            app.DeepWaterAcousticsListBox = uilistbox(app.UIWaveBasinDataViewerUIFigure);
            app.DeepWaterAcousticsListBox.Items = {};
            app.DeepWaterAcousticsListBox.Tooltip = {'Ultrasonic wave height measurements beyond the end of the beach.'};
            app.DeepWaterAcousticsListBox.Position = [679 315 125 129];
            app.DeepWaterAcousticsListBox.Value = {};

            % Create RAWBreakerMeasurementsLabel
            app.RAWBreakerMeasurementsLabel = uilabel(app.UIWaveBasinDataViewerUIFigure);
            app.RAWBreakerMeasurementsLabel.HorizontalAlignment = 'center';
            app.RAWBreakerMeasurementsLabel.FontWeight = 'bold';
            app.RAWBreakerMeasurementsLabel.Position = [826 450 90 28];
            app.RAWBreakerMeasurementsLabel.Text = {'RAW Breaker '; 'Measurements'};

            % Create RAWBreakerMeasurementsListBox
            app.RAWBreakerMeasurementsListBox = uilistbox(app.UIWaveBasinDataViewerUIFigure);
            app.RAWBreakerMeasurementsListBox.Items = {};
            app.RAWBreakerMeasurementsListBox.Tooltip = {'Raw measurements breaking waves collected using co-located acoustic sensors and NRL DeltaFluid sensors.'; ''; 'Note: Select which of the collocated signals to display using checkboxes below.'};
            app.RAWBreakerMeasurementsListBox.Position = [818 253 107 193];
            app.RAWBreakerMeasurementsListBox.Value = {};

            % Create MQSInputsLabel
            app.MQSInputsLabel = uilabel(app.UIWaveBasinDataViewerUIFigure);
            app.MQSInputsLabel.HorizontalAlignment = 'center';
            app.MQSInputsLabel.FontSize = 14;
            app.MQSInputsLabel.FontAngle = 'italic';
            app.MQSInputsLabel.Position = [443 485 150 22];
            app.MQSInputsLabel.Text = 'MQS Inputs';

            % Create RawMoCapDataLabel
            app.RawMoCapDataLabel = uilabel(app.UIWaveBasinDataViewerUIFigure);
            app.RawMoCapDataLabel.HorizontalAlignment = 'center';
            app.RawMoCapDataLabel.FontSize = 14;
            app.RawMoCapDataLabel.FontAngle = 'italic';
            app.RawMoCapDataLabel.Position = [41 485 150 22];
            app.RawMoCapDataLabel.Text = 'Raw MoCap Data';

            % Create GapFilledKalmanFilteredMoCapDataLabel
            app.GapFilledKalmanFilteredMoCapDataLabel = uilabel(app.UIWaveBasinDataViewerUIFigure);
            app.GapFilledKalmanFilteredMoCapDataLabel.HorizontalAlignment = 'center';
            app.GapFilledKalmanFilteredMoCapDataLabel.FontSize = 14;
            app.GapFilledKalmanFilteredMoCapDataLabel.FontAngle = 'italic';
            app.GapFilledKalmanFilteredMoCapDataLabel.Position = [26 315 157 41];
            app.GapFilledKalmanFilteredMoCapDataLabel.Text = {'Gap-Filled / Kalman-'; 'Filtered MoCap Data'};

            % Create IMUDataLabel
            app.IMUDataLabel = uilabel(app.UIWaveBasinDataViewerUIFigure);
            app.IMUDataLabel.HorizontalAlignment = 'center';
            app.IMUDataLabel.FontSize = 14;
            app.IMUDataLabel.FontAngle = 'italic';
            app.IMUDataLabel.Position = [242 485 141 22];
            app.IMUDataLabel.Text = 'IMU Data';

            % Create WaveMeasurementsLabel
            app.WaveMeasurementsLabel = uilabel(app.UIWaveBasinDataViewerUIFigure);
            app.WaveMeasurementsLabel.HorizontalAlignment = 'center';
            app.WaveMeasurementsLabel.FontSize = 14;
            app.WaveMeasurementsLabel.FontAngle = 'italic';
            app.WaveMeasurementsLabel.Position = [767 485 171 22];
            app.WaveMeasurementsLabel.Text = 'Wave Measurements';

            % Create CSVExportButton
            app.CSVExportButton = uibutton(app.UIWaveBasinDataViewerUIFigure, 'push');
            app.CSVExportButton.ButtonPushedFcn = createCallbackFcn(app, @CSVExportButtonPushed, true);
            app.CSVExportButton.FontSize = 14;
            app.CSVExportButton.FontWeight = 'bold';
            app.CSVExportButton.Tooltip = {'Export ALL data (except DeltaFluid wetting field data) to tab-delimited ASCII files. One file will be created per selected sub-trial.'};
            app.CSVExportButton.Position = [667 64 106 46];
            app.CSVExportButton.Text = {'CSV '; 'Export'};

            % Create PlayVideosButton
            app.PlayVideosButton = uibutton(app.UIWaveBasinDataViewerUIFigure, 'push');
            app.PlayVideosButton.ButtonPushedFcn = createCallbackFcn(app, @PlayVideosButtonPushed, true);
            app.PlayVideosButton.FontSize = 14;
            app.PlayVideosButton.FontWeight = 'bold';
            app.PlayVideosButton.Tooltip = {'Opens a pop-out window with a table of hyperlinked videos available for the currently-loaded run. Videos will load in the system''s default internet browser.'};
            app.PlayVideosButton.Position = [667 116 106 46];
            app.PlayVideosButton.Text = {'Play '; 'Videos'};

            % Create FusedBreakerMeasurementsLabel
            app.FusedBreakerMeasurementsLabel = uilabel(app.UIWaveBasinDataViewerUIFigure);
            app.FusedBreakerMeasurementsLabel.HorizontalAlignment = 'center';
            app.FusedBreakerMeasurementsLabel.FontWeight = 'bold';
            app.FusedBreakerMeasurementsLabel.Position = [944 449 92 28];
            app.FusedBreakerMeasurementsLabel.Text = {'Fused Breaker '; 'Measurements'};

            % Create FusedBreakerMeasurementsListBox
            app.FusedBreakerMeasurementsListBox = uilistbox(app.UIWaveBasinDataViewerUIFigure);
            app.FusedBreakerMeasurementsListBox.Items = {};
            app.FusedBreakerMeasurementsListBox.Tooltip = {'Measurements of breaking waves. Data fused from co-located acoustic sensors and NRL DeltaFluid Sensors.'; ''; 'Note: Select which of the collocated signals to display using checkboxes below.'};
            app.FusedBreakerMeasurementsListBox.Position = [938 252 107 193];
            app.FusedBreakerMeasurementsListBox.Value = {};

            % Create WaveSensorLocationsButton
            app.WaveSensorLocationsButton = uibutton(app.UIWaveBasinDataViewerUIFigure, 'push');
            app.WaveSensorLocationsButton.ButtonPushedFcn = createCallbackFcn(app, @WaveSensorLocationsButtonPushed, true);
            app.WaveSensorLocationsButton.FontWeight = 'bold';
            app.WaveSensorLocationsButton.Tooltip = {'View 3D map of wave measurement sensor layout'};
            app.WaveSensorLocationsButton.Position = [933 597 112 37];
            app.WaveSensorLocationsButton.Text = {'Wave Sensor '; 'Locations'};

            % Create ROSCommandsListBoxLabel
            app.ROSCommandsListBoxLabel = uilabel(app.UIWaveBasinDataViewerUIFigure);
            app.ROSCommandsListBoxLabel.HorizontalAlignment = 'center';
            app.ROSCommandsListBoxLabel.FontWeight = 'bold';
            app.ROSCommandsListBoxLabel.Position = [553 449 83 28];
            app.ROSCommandsListBoxLabel.Text = {'ROS '; 'Commands'};

            % Create ROSCommandsListBox
            app.ROSCommandsListBox = uilistbox(app.UIWaveBasinDataViewerUIFigure);
            app.ROSCommandsListBox.Items = {};
            app.ROSCommandsListBox.Tooltip = {'MQS command signals broadcast from the ROS control computer. Note: synchronization with other signal types may be imperfect due to software timestamping.'};
            app.ROSCommandsListBox.Position = [538 203 113 241];
            app.ROSCommandsListBox.Value = {};

            % Create Image
            app.Image = uiimage(app.UIWaveBasinDataViewerUIFigure);
            app.Image.Position = [937 21 121 53];
            app.Image.ImageSource = 'MELogo.png';

            % Create Image_2
            app.Image_2 = uiimage(app.UIWaveBasinDataViewerUIFigure);
            app.Image_2.Position = [795 11 144 63];
            app.Image_2.ImageSource = 'IIHRLogo.png';

            % Create ListofSignalsButton
            app.ListofSignalsButton = uibutton(app.UIWaveBasinDataViewerUIFigure, 'push');
            app.ListofSignalsButton.ButtonPushedFcn = createCallbackFcn(app, @ListofSignalsButtonPushed, true);
            app.ListofSignalsButton.FontWeight = 'bold';
            app.ListofSignalsButton.Tooltip = {'View list of signals, units, and descriptions in a separate window.'};
            app.ListofSignalsButton.Position = [933 648 112 37];
            app.ListofSignalsButton.Text = 'List of Signals';

            % Create DeltaFluidFieldCheckBox
            app.DeltaFluidFieldCheckBox = uicheckbox(app.UIWaveBasinDataViewerUIFigure);
            app.DeltaFluidFieldCheckBox.Tooltip = {'Raw outputs from NRL DeltaFluid wetting sensors'};
            app.DeltaFluidFieldCheckBox.Text = 'DeltaFluid - Field';
            app.DeltaFluidFieldCheckBox.Position = [818 223 113 22];
            app.DeltaFluidFieldCheckBox.Value = true;

            % Create AcousticGaugesCheckBox
            app.AcousticGaugesCheckBox = uicheckbox(app.UIWaveBasinDataViewerUIFigure);
            app.AcousticGaugesCheckBox.Tooltip = {'Senix acoustic distance sensors co-located with DeltaFluid wetting sensors.'};
            app.AcousticGaugesCheckBox.Text = 'Acoustic Gauges';
            app.AcousticGaugesCheckBox.Position = [818 201 113 22];
            app.AcousticGaugesCheckBox.Value = true;

            % Create DeltaFluidFieldCheckBox_2
            app.DeltaFluidFieldCheckBox_2 = uicheckbox(app.UIWaveBasinDataViewerUIFigure);
            app.DeltaFluidFieldCheckBox_2.Tooltip = {'Cross-sections of breakers, measured using a fusion of NRL wetting sensors and acoustic gauges.'};
            app.DeltaFluidFieldCheckBox_2.Text = 'DeltaFluid - Field';
            app.DeltaFluidFieldCheckBox_2.Position = [939 223 113 22];
            app.DeltaFluidFieldCheckBox_2.Value = true;

            % Create ApproximatesurfacecontourCheckBox
            app.ApproximatesurfacecontourCheckBox = uicheckbox(app.UIWaveBasinDataViewerUIFigure);
            app.ApproximatesurfacecontourCheckBox.Tooltip = {'Approximate trace of free-surface (one-to-one) from fused data.'};
            app.ApproximatesurfacecontourCheckBox.Text = {'Approximate '; 'surface contour'};
            app.ApproximatesurfacecontourCheckBox.Position = [939 195 105 28];
            app.ApproximatesurfacecontourCheckBox.Value = true;

            % Create SecondsprereleaseSpinnerLabel
            app.SecondsprereleaseSpinnerLabel = uilabel(app.UIWaveBasinDataViewerUIFigure);
            app.SecondsprereleaseSpinnerLabel.HorizontalAlignment = 'right';
            app.SecondsprereleaseSpinnerLabel.Position = [204 140 116 22];
            app.SecondsprereleaseSpinnerLabel.Text = 'Seconds pre-release';

            % Create SecondspostreleaseSpinnerLabel
            app.SecondspostreleaseSpinnerLabel = uilabel(app.UIWaveBasinDataViewerUIFigure);
            app.SecondspostreleaseSpinnerLabel.HorizontalAlignment = 'right';
            app.SecondspostreleaseSpinnerLabel.Position = [198 116 122 22];
            app.SecondspostreleaseSpinnerLabel.Text = 'Seconds post-release';

            % Create SecondspostreleaseSpinner
            app.SecondspostreleaseSpinner = uispinner(app.UIWaveBasinDataViewerUIFigure);
            app.SecondspostreleaseSpinner.Limits = [0 1000];
            app.SecondspostreleaseSpinner.ValueChangedFcn = createCallbackFcn(app, @SecondspostreleaseSpinnerValueChanged, true);
            app.SecondspostreleaseSpinner.Tooltip = {'Set the end-time of a sub-trial window, relative to the MQS release trigger.'};
            app.SecondspostreleaseSpinner.Position = [335 116 68 19];
            app.SecondspostreleaseSpinner.Value = 40;

            % Create SubtrialwindowsettingsLabel
            app.SubtrialwindowsettingsLabel = uilabel(app.UIWaveBasinDataViewerUIFigure);
            app.SubtrialwindowsettingsLabel.FontWeight = 'bold';
            app.SubtrialwindowsettingsLabel.Tooltip = {'Sets the times, relative to the model release, for which data will be processed as belonging to that sub-trial.'};
            app.SubtrialwindowsettingsLabel.Position = [207 161 155 22];
            app.SubtrialwindowsettingsLabel.Text = 'Sub-trial window settings:';

            % Create RunParametersMetadataTextAreaLabel_2
            app.RunParametersMetadataTextAreaLabel_2 = uilabel(app.UIWaveBasinDataViewerUIFigure);
            app.RunParametersMetadataTextAreaLabel_2.HorizontalAlignment = 'center';
            app.RunParametersMetadataTextAreaLabel_2.FontWeight = 'bold';
            app.RunParametersMetadataTextAreaLabel_2.Position = [942 691 94 28];
            app.RunParametersMetadataTextAreaLabel_2.Text = {'Additional Run '; 'Information'};

            % Create ModelMassPropertiesButton
            app.ModelMassPropertiesButton = uibutton(app.UIWaveBasinDataViewerUIFigure, 'push');
            app.ModelMassPropertiesButton.ButtonPushedFcn = createCallbackFcn(app, @ModelMassPropertiesButtonPushed, true);
            app.ModelMassPropertiesButton.FontWeight = 'bold';
            app.ModelMassPropertiesButton.Tooltip = {'Display the mass properties of the MQS.'};
            app.ModelMassPropertiesButton.Position = [933 546 112 37];
            app.ModelMassPropertiesButton.Text = {'Model Mass '; 'Properties'};

            % Create SecondsprereleaseSpinner
            app.SecondsprereleaseSpinner = uispinner(app.UIWaveBasinDataViewerUIFigure);
            app.SecondsprereleaseSpinner.Limits = [0 1000];
            app.SecondsprereleaseSpinner.ValueChangedFcn = createCallbackFcn(app, @SecondsprereleaseSpinnerValueChanged, true);
            app.SecondsprereleaseSpinner.Tooltip = {'Set the start time of a sub-trial window, relative to the MQS release trigger.'};
            app.SecondsprereleaseSpinner.Position = [335 140 68 19];
            app.SecondsprereleaseSpinner.Value = 10;

            % Create Image_3
            app.Image_3 = uiimage(app.UIWaveBasinDataViewerUIFigure);
            app.Image_3.Position = [937 90 121 65];
            app.Image_3.ImageSource = 'Naval_Research_Laboratory_Logo.png';

            % Create Image_4
            app.Image_4 = uiimage(app.UIWaveBasinDataViewerUIFigure);
            app.Image_4.Position = [807 80 121 84];
            app.Image_4.ImageSource = 'g3216.png';

            % Create UITable
            app.UITable = uitable(app.UIWaveBasinDataViewerUIFigure);
            app.UITable.ColumnName = '';
            app.UITable.RowName = {};
            app.UITable.Position = [258 546 658 139];

            % Create FilesCurrentlyOpenListBoxLabel
            app.FilesCurrentlyOpenListBoxLabel = uilabel(app.UIWaveBasinDataViewerUIFigure);
            app.FilesCurrentlyOpenListBoxLabel.HorizontalAlignment = 'right';
            app.FilesCurrentlyOpenListBoxLabel.FontWeight = 'bold';
            app.FilesCurrentlyOpenListBoxLabel.Position = [63 588 132 22];
            app.FilesCurrentlyOpenListBoxLabel.Text = 'File(s) Currently Open';

            % Create FilesCurrentlyOpenListBox
            app.FilesCurrentlyOpenListBox = uilistbox(app.UIWaveBasinDataViewerUIFigure);
            app.FilesCurrentlyOpenListBox.Items = {};
            app.FilesCurrentlyOpenListBox.Tooltip = {'List of data files currently loaded into memory.'};
            app.FilesCurrentlyOpenListBox.Position = [33 538 191 50];
            app.FilesCurrentlyOpenListBox.Value = {};

            % Create PlotEnsembleAverageButton
            app.PlotEnsembleAverageButton = uibutton(app.UIWaveBasinDataViewerUIFigure, 'push');
            app.PlotEnsembleAverageButton.ButtonPushedFcn = createCallbackFcn(app, @PlotEnsembleAverageButtonPushed, true);
            app.PlotEnsembleAverageButton.FontSize = 14;
            app.PlotEnsembleAverageButton.FontWeight = 'bold';
            app.PlotEnsembleAverageButton.Tooltip = {'Plot the ensemble mean and standard deviation of the selected runs and sub-trials.'};
            app.PlotEnsembleAverageButton.Position = [425 64 106 46];
            app.PlotEnsembleAverageButton.Text = {'Plot Ensemble'; 'Average'};

            % Create FFTButton
            app.FFTButton = uibutton(app.UIWaveBasinDataViewerUIFigure, 'push');
            app.FFTButton.ButtonPushedFcn = createCallbackFcn(app, @FFTButtonPushed, true);
            app.FFTButton.FontSize = 14;
            app.FFTButton.FontWeight = 'bold';
            app.FFTButton.Tooltip = {'Plot the FFT of selected signals during the specified time window.'};
            app.FFTButton.Position = [547 116 106 46];
            app.FFTButton.Text = 'FFT';

            % Create CloseAllFiguresButton
            app.CloseAllFiguresButton = uibutton(app.UIWaveBasinDataViewerUIFigure, 'push');
            app.CloseAllFiguresButton.ButtonPushedFcn = createCallbackFcn(app, @CloseAllFiguresButtonPushed, true);
            app.CloseAllFiguresButton.FontSize = 14;
            app.CloseAllFiguresButton.FontWeight = 'bold';
            app.CloseAllFiguresButton.Tooltip = {'Closes all open plotting windows.'};
            app.CloseAllFiguresButton.Position = [425 16 105 46];
            app.CloseAllFiguresButton.Text = {'Close All '; 'Figures'};

            % Create OpenTrialClusterGroupButton
            app.OpenTrialClusterGroupButton = uibutton(app.UIWaveBasinDataViewerUIFigure, 'push');
            app.OpenTrialClusterGroupButton.ButtonPushedFcn = createCallbackFcn(app, @OpenTrialClusterGroupButtonPushed, true);
            app.OpenTrialClusterGroupButton.FontWeight = 'bold';
            app.OpenTrialClusterGroupButton.Tooltip = {'Opens a pre-determined cluster of trials and sub-trials at the same test conditions and with similar response patterns.'};
            app.OpenTrialClusterGroupButton.Position = [33 655 193 30];
            app.OpenTrialClusterGroupButton.Text = 'Open Trial Cluster / Group';

            % Create PlotCustomXvsYButton
            app.PlotCustomXvsYButton = uibutton(app.UIWaveBasinDataViewerUIFigure, 'push');
            app.PlotCustomXvsYButton.ButtonPushedFcn = createCallbackFcn(app, @PlotCustomXvsYButtonPushed, true);
            app.PlotCustomXvsYButton.FontSize = 14;
            app.PlotCustomXvsYButton.FontWeight = 'bold';
            app.PlotCustomXvsYButton.Tooltip = {'Plot ensemble means and 1-sigma envelopes of selected (sub)trials with user-selected X-Y pairs, parameterized by time.'};
            app.PlotCustomXvsYButton.Position = [547 64 106 46];
            app.PlotCustomXvsYButton.Text = {'Plot Custom '; 'X vs Y'};

            % Create VelocityBodyFixedLabel
            app.VelocityBodyFixedLabel = uilabel(app.UIWaveBasinDataViewerUIFigure);
            app.VelocityBodyFixedLabel.HorizontalAlignment = 'center';
            app.VelocityBodyFixedLabel.FontWeight = 'bold';
            app.VelocityBodyFixedLabel.Position = [301 289 79 28];
            app.VelocityBodyFixedLabel.Text = {'Velocity'; '(Body-Fixed)'};

            % Create VelocityBodyFixedListBox
            app.VelocityBodyFixedListBox = uilistbox(app.UIWaveBasinDataViewerUIFigure);
            app.VelocityBodyFixedListBox.Items = {};
            app.VelocityBodyFixedListBox.Tooltip = {'Velocities of MQS datum. Measured in global coordinate system. Fused with IMU data to fill gaps and reduce noise.'};
            app.VelocityBodyFixedListBox.Position = [305 206 69 81];
            app.VelocityBodyFixedListBox.Value = {};

            % Create GroundContactLabel
            app.GroundContactLabel = uilabel(app.UIWaveBasinDataViewerUIFigure);
            app.GroundContactLabel.HorizontalAlignment = 'center';
            app.GroundContactLabel.FontWeight = 'bold';
            app.GroundContactLabel.Position = [693 267 97 22];
            app.GroundContactLabel.Text = 'Ground Contact';

            % Create GroundContactListBox
            app.GroundContactListBox = uilistbox(app.UIWaveBasinDataViewerUIFigure);
            app.GroundContactListBox.Items = {};
            app.GroundContactListBox.Tooltip = {'Angular velocities of the MQS, measured at the location of the IMU and reported in MQS coordinate system.'};
            app.GroundContactListBox.Position = [679 203 126 63];
            app.GroundContactListBox.Value = {};

            % Create VelocitiesLabel
            app.VelocitiesLabel = uilabel(app.UIWaveBasinDataViewerUIFigure);
            app.VelocitiesLabel.HorizontalAlignment = 'center';
            app.VelocitiesLabel.FontSize = 14;
            app.VelocitiesLabel.FontAngle = 'italic';
            app.VelocitiesLabel.Position = [230 315 146 41];
            app.VelocitiesLabel.Text = 'Velocities';

            % Show the figure after all components are created
            app.UIWaveBasinDataViewerUIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = UI_MQS_DataViewer_V4_Script

            % Create UIFigure and components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.UIWaveBasinDataViewerUIFigure)

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.UIWaveBasinDataViewerUIFigure)
        end
    end
end