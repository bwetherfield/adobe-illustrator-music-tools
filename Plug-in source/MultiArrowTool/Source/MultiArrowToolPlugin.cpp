//========================================================================================
//
//  $File: //ai/mainline/devtech/sdk/public/samplecode/MultiArrowTool/Source/MultiArrowToolPlugin.cpp $
//
//  $Revision: #12 $
//
//  Copyright 1987 Adobe Systems Incorporated. All rights reserved.
//
//  NOTICE:  Adobe permits you to use, modify, and distribute this file in accordance
//  with the terms of the Adobe license agreement accompanying it.  If you have received
//  this file from a source other than Adobe, then your use, modification, or
//  distribution of it requires the prior written permission of Adobe.
//
//========================================================================================

//
// NOTE: This plugin has been adapted to produce musical "hairpin" symbols (crescendo, diminuendo,
// flared crescendo, flared diminuendo) instead of arrows.
//
// Copyright Ben Wetherfield 2014
//

#include "IllustratorSDK.h"
#include "MultiArrowToolPlugin.h"
#include "SDKErrors.h"

#define kHeadArrowTool			"$$$/MulitiArrowTool/Str/HeadArrowTool=Crescendo Tool"
#define kTailArrowTool			"$$$/MulitiArrowTool/Str/TailArrowTool=Diminuendo Tool"
#define kBothEndsArrowTool		"$$$/MulitiArrowTool/Str/BothEndsArrowTool=Flared Crescendo Tool"
#define kStraightLineTool		"$$$/MulitiArrowTool/Str/StraightLineTool=Flared Diminuendo Tool"
/*
 */
Plugin* AllocatePlugin(SPPluginRef pluginRef)
{
	return new MultiArrowToolPlugin(pluginRef);
}

/*
 */
void FixupReload(Plugin* plugin)
{
	MultiArrowToolPlugin::FixupVTable((MultiArrowToolPlugin*) plugin);
}

/*
 */
MultiArrowToolPlugin::MultiArrowToolPlugin(SPPluginRef pluginRef)
: Plugin(pluginRef),
fResourceManagerHandle(NULL),
fShutdownApplicationNotifier(NULL),
fNotifySelectionChanged(NULL)
{
	strncpy(fPluginName, kMultiArrowToolPluginName, kMaxStringLength);
}

/*
 */
ASErr MultiArrowToolPlugin::Message(char* caller, char* selector, void *message)
{
	ASErr error = kNoErr;
    
	try
	{
		error = Plugin::Message(caller, selector, message);
	}
	catch (ai::Error& ex) {
		error = ex;
	}
	catch (...) {
		error = kCantHappenErr;
	}
    
	if (error)
	{
		if (error == kUnhandledMsgErr)
		{
			if (strcmp(caller, kCallerAIAnnotation) == 0)
			{
				if (strcmp(selector, kSelectorAIDrawAnnotation) == 0)
				{
					error = DrawAnnotator((AIAnnotatorMessage*)message);
					aisdk::check_ai_error(error);
				}
				else if (strcmp(selector, kSelectorAIInvalAnnotation) == 0)
				{
					error = InvalAnnotator((AIAnnotatorMessage*)message);
					aisdk::check_ai_error(error);
				}
			}
            
            
		}
		else
		{
			Plugin::ReportError(error, caller, selector, message);
		}
	}
	return error;
}

ASErr MultiArrowToolPlugin::Notify( AINotifierMessage *message )
{
	ASErr error = kNoErr;
	if (message->notifier == fShutdownApplicationNotifier)
	{
		if(fResourceManagerHandle != NULL)
		{
			error = sAIUser->DisposeCursorResourceMgr(fResourceManagerHandle);
			fResourceManagerHandle = NULL;
		}
	}
	else if (message->notifier == fNotifySelectionChanged) {
        // Get the bounds of the current document view.
        AIRealRect viewBounds = {0, 0, 0, 0};
        error = sAIDocumentView->GetDocumentViewBounds(NULL, &viewBounds);
        aisdk::check_ai_error(error);
        // Invalidate the entire document view bounds.
        error = InvalidateRect(viewBounds);
        aisdk::check_ai_error(error);
	}
	return error;
}
/*
 */
ASErr MultiArrowToolPlugin::StartupPlugin(SPInterfaceMessage* message)
{
	ASErr error = kNoErr;
	ai::int32 pluginOptions = 0;
	
	error = Plugin::StartupPlugin(message);
	if (error) goto error;
	
	error = sAIPlugin->GetPluginOptions(message->d.self, &pluginOptions);
	if (error) goto error;
	
	error = sAIPlugin->SetPluginOptions(message->d.self, pluginOptions | kPluginWantsResultsAutoSelectedOption );
	if (error) goto error;
	
	error = AddTools(message);
	if (error) goto error;
    
	error = AddAnnotator(message);
	if (error) goto error;
    
	error = AddMenus(message);
	if (error) goto error;
    
	error = AddNotifier(message);
	if (error) goto error;
    
error:
	return error;
}

/*
 */
ASErr MultiArrowToolPlugin::GoMenuItem(AIMenuMessage* message)
{
	ASErr error = kNoErr;
	if (message->menuItem == this->fAboutPluginMenu) {
		// Pop this plug-in's about box.
		SDKAboutPluginsHelper aboutPluginsHelper;
		aboutPluginsHelper.PopAboutBox(message, "About MultiArrowTool", kSDKDefAboutSDKCompanyPluginsAlertString);
	}
	return error;
}

/*
 */
ASErr MultiArrowToolPlugin::AddMenus(SPInterfaceMessage* message)
{
	ASErr error = kNoErr;
	// Add a menu item to the About SDK Plug-ins menu group.
	SDKAboutPluginsHelper aboutPluginsHelper;
	error = aboutPluginsHelper.AddAboutPluginsMenuItem(message,
                                                       kSDKDefAboutSDKCompanyPluginsGroupName,
                                                       ai::UnicodeString(kSDKDefAboutSDKCompanyPluginsGroupNameString),
                                                       "MultiArrowTool...",
                                                       &fAboutPluginMenu);
	return error;
}

/*
 */
ASErr MultiArrowToolPlugin::AddTools(SPInterfaceMessage* message)
{
	AIErr error = kNoErr;
	AIAddToolData toolData;
    
	ai::int32			options = kToolWantsToTrackCursorOption;
    
	char firstToolName[256];
	ai::UnicodeString toolTitleStr[4];
	toolTitleStr[0] = ai::UnicodeString(ZREF(kHeadArrowTool));
	toolTitleStr[1] = ai::UnicodeString(ZREF(kTailArrowTool));
	toolTitleStr[2] = ai::UnicodeString(ZREF(kBothEndsArrowTool));
	toolTitleStr[3] = ai::UnicodeString(ZREF(kStraightLineTool));
    
	ai::uint32 iconName[4];
	iconName[0] = kHeadArrowToolIconResID;
	iconName[1] = kTailArrowToolIconResID;
	iconName[2] = kBothEndsArrowToolIconResID;
	iconName[3] = kStraightLineToolIconResID;
    
	ai::uint32 darkIconName[4];
	darkIconName[0] = kHeadArrowToolIconDarkResID;
	darkIconName[1] = kTailArrowToolIconDarkResID;
	darkIconName[2] = kBothEndsArrowToolIconDarkResID;
	darkIconName[3] = kStraightLineToolIconDarkResID;
    
	short i;
	for ( i = 0 ; i < 4 ; i++ ) {
        
		std::string toolTitle = toolTitleStr[i].as_Platform();
		toolData.title = toolTitle.c_str();
		toolData.tooltip = toolTitle.c_str();
		toolData.darkIconResID = darkIconName[i];
		toolData.normalIconResID = iconName[i];
		if ( i == 0 )
		{
            strcpy( firstToolName, toolData.title);
			// New group on tool palette.
			toolData.sameGroupAs = kNoTool;
			// New toolset in new group.
			toolData.sameToolsetAs = kNoTool;
			
		}
		else
		{
			error = sAITool->GetToolNumberFromName( firstToolName, &toolData.sameGroupAs);
			error = sAITool->GetToolNumberFromName( firstToolName, &toolData.sameToolsetAs);
		}
        
		error = sAITool->AddTool( message->d.self, toolData.title, &toolData,
                                 options, &fToolHandle[i] );
		if (error)
			goto errorTag;
	}
    
errorTag:
	return error;
}

ASErr MultiArrowToolPlugin::AddNotifier(SPInterfaceMessage *message)
{
	ASErr result = kNoErr;
	try {
		result = sAINotifier->AddNotifier(fPluginRef, "MultiArrowToolPlugin", kAIApplicationShutdownNotifier, &fShutdownApplicationNotifier);
		aisdk::check_ai_error(result);
		result = sAINotifier->AddNotifier(fPluginRef, "MultiArrowToolPlugin", kAIArtSelectionChangedNotifier, &fNotifySelectionChanged);
        
		aisdk::check_ai_error(result);
	}
	catch (ai::Error& ex) {
		result = ex;
	}
	catch(...)
	{
		result = kCantHappenErr;
	}
	return result;
}

/*
 */
ASErr MultiArrowToolPlugin::TrackToolCursor(AIToolMessage* message)
{
	AIErr error = kNoErr;
	ai::int32 cursorId = kHeadArrowToolIconResID;
	
	if ( message->tool == this->fToolHandle[1] )
		cursorId = kTailArrowToolIconResID;
	else if ( message->tool == this->fToolHandle[2] )
		cursorId = kBothEndsArrowToolIconResID;
	else if ( message->tool == this->fToolHandle[3] )
		cursorId = kStraightLineToolIconResID;
    
	if(sAIUser != NULL)
		error = sAIUser->SetCursor(cursorId, fResourceManagerHandle);
    
	return error;
}

/*
 */
ASErr MultiArrowToolPlugin::ToolMouseDown(AIToolMessage* message)
{
	ASErr error = kNoErr;
    
	// we want our initial mouse down to base the drag on later
	this->fStartingPoint = message->cursor;
	
	// Activate annotator.
	error = sAIAnnotator->SetAnnotatorActive(fAnnotatorHandle, true);
	
	return error;
}

/*
 */
ASErr MultiArrowToolPlugin::ToolMouseUp(AIToolMessage* message)
{
	ASErr error = kNoErr;
    
	// Deactivates annotator.
	error = sAIAnnotator->SetAnnotatorActive(fAnnotatorHandle, false);
	
	return error;
}

/*
 */
ASErr MultiArrowToolPlugin::ToolMouseDrag(AIToolMessage* message)
{
	ASErr error = kNoErr;
	AIArtHandle path;
	AIPathSegment segments[9];
	AIReal pathAngle, arrowAngle, arrowAngle2;
	AIRealPoint arrowPt1, arrowPt2, arrowPt3, arrowPt4;
	AIPathStyle pathStyle;
	AIPathStyleMap pathStyleMap;
	AIDictionaryRef advStrokeParams = NULL;
	
	error = sAIUndo->UndoChanges( );
    
	this->fEndPoint = message->cursor;
    
	// Invalidate the old Annotation
	error = InvalidateRect(oldAnnotatorRect);
	aisdk::check_ai_error(error);
	
	// Create new art, we will fill it with points below.
	error = sAIArt->NewArt( kPathArt, kPlaceAboveAll, NULL, &path );
	if ( error )
		goto error;
    
	if (message->event->modifiers & aiEventModifiers_shiftKey)
	{
		short angle = (short)(abs((int)(sAIRealMath->RadianToDegree(sAIRealMath->AIRealPointAngle(&this->fStartingPoint, &this->fEndPoint)))));
        
		if (angle < 45 || angle > 135)
		{
			this->fEndPoint.v = this->fStartingPoint.v;
		}
		else
		{
			this->fEndPoint.h = this->fStartingPoint.h;
		}
	}
    
	
	if ( message->tool == this->fToolHandle[0] ) {
        
		// CRESCENDO tool
		error = sAIPath->SetPathSegmentCount( path, 4 );
        
		// The point of the crescendo
		segments[0].p.h = this->fStartingPoint.h;
		segments[0].p.v = this->fStartingPoint.v;
		segments[0].in = segments[0].out = segments[0].p;
		segments[0].corner = true;
        
		// angle created by line segment
		pathAngle = sAIRealMath->AIRealPointAngle( &this->fEndPoint, &this->fStartingPoint );
		arrowAngle = sAIRealMath->DegreeToRadian( _ShortToAIReal(20) );
        
		sAIRealMath->AIRealPointLengthAngle( _ShortToAIReal(10), pathAngle + arrowAngle, &arrowPt1 );
		sAIRealMath->AIRealPointLengthAngle( _ShortToAIReal(10), pathAngle - arrowAngle, &arrowPt2 );
        
        // one side of the opening
		segments[1].p.h = this->fEndPoint.h + arrowPt1.h;
		segments[1].p.v = this->fEndPoint.v + arrowPt1.v;
		segments[1].in = segments[1].out = segments[1].p;
		segments[1].corner = true;
        
        // back to the point of the crescendo
        segments[2].p.h = this->fStartingPoint.h;
        segments[2].p.v = this->fStartingPoint.v;
        segments[2].in = segments[2].out = segments[2].p;
        segments[2].corner = true;
        
        // the other side of the opening
		segments[3].p.h = this->fEndPoint.h + arrowPt2.h;
		segments[3].p.v = this->fEndPoint.v + arrowPt2.v;
		segments[3].in = segments[3].out = segments[3].p;
		segments[3].corner = true;
        
		error = sAIPath->SetPathSegments( path, 0, 4, segments );
		if ( error )
			goto error;
        
    }
    
	else if ( message->tool == this->fToolHandle[1] ) {
		
		//	DIMINUENDO
        error = sAIPath->SetPathSegmentCount( path, 4 );
        
        // the point of the diminuendo of the crescendo
        segments[0].p.h = this->fEndPoint.h;
        segments[0].p.v = this->fEndPoint.v;
        segments[0].in = segments[0].out = segments[0].p;
        segments[0].corner = true;
        
        // angle created by line segment
        pathAngle = sAIRealMath->AIRealPointAngle( &this->fEndPoint, &this->fStartingPoint );
        arrowAngle = sAIRealMath->DegreeToRadian( _ShortToAIReal(20) );
        
        sAIRealMath->AIRealPointLengthAngle( _ShortToAIReal(10), pathAngle + arrowAngle, &arrowPt1 );
        sAIRealMath->AIRealPointLengthAngle( _ShortToAIReal(10), pathAngle - arrowAngle, &arrowPt2 );
        
        // one side of the opening
        segments[1].p.h = this->fStartingPoint.h - arrowPt1.h;
        segments[1].p.v = this->fStartingPoint.v - arrowPt1.v;
        segments[1].in = segments[1].out = segments[1].p;
        segments[1].corner = true;
        
        // back to the point of the diminuendo
        segments[2].p.h = this->fEndPoint.h;
        segments[2].p.v = this->fEndPoint.v;
        segments[2].in = segments[2].out = segments[2].p;
        segments[2].corner = true;
        
        // the other side of the opening
        segments[3].p.h = this->fStartingPoint.h - arrowPt2.h;
        segments[3].p.v = this->fStartingPoint.v - arrowPt2.v;
        segments[3].in = segments[3].out = segments[3].p;
        segments[3].corner = true;
        
        error = sAIPath->SetPathSegments( path, 0, 4, segments );
        if ( error )
            goto error;
        
    }
    
    
    else if ( message->tool == this->fToolHandle[2] ) {
        
		//	FLARED CRESCENDO tool
		error = sAIPath->SetPathSegmentCount( path, 9 );
        
		// The point of the crescendo
		segments[0].p.h = this->fStartingPoint.h;
		segments[0].p.v = this->fStartingPoint.v;
		segments[0].in = segments[0].out = segments[0].p;
		segments[0].corner = true;
        
		// angles created by line segments
		pathAngle = sAIRealMath->AIRealPointAngle( &this->fEndPoint, &this->fStartingPoint );
		arrowAngle = sAIRealMath->DegreeToRadian( _ShortToAIReal(8) );
        arrowAngle2 = sAIRealMath->DegreeToRadian( _ShortToAIReal(30));
		sAIRealMath->AIRealPointLengthAngle( _ShortToAIReal(10), pathAngle + arrowAngle, &arrowPt1 );
        sAIRealMath->AIRealPointLengthAngle( _ShortToAIReal(9), pathAngle + arrowAngle2, &arrowPt3 );
		sAIRealMath->AIRealPointLengthAngle( _ShortToAIReal(10), pathAngle - arrowAngle, &arrowPt2 );
        sAIRealMath->AIRealPointLengthAngle( _ShortToAIReal(9), pathAngle - arrowAngle2, &arrowPt4 );
        
		// one side of the opening
		segments[1].p.h = this->fEndPoint.h + arrowPt1.h;
		segments[1].p.v = this->fEndPoint.v + arrowPt1.v;
		segments[1].in = segments[1].out = segments[1].p;
		segments[1].corner = true;
        
        // flared part of the crescendo on that side
		segments[2].p.h = this->fEndPoint.h + arrowPt3.h;
		segments[2].p.v = this->fEndPoint.v + arrowPt3.v;
		segments[2].in = segments[2].out = segments[2].p;
		segments[2].corner = true;
        
        // back to the point of the opening of the crescendo
		segments[3].p.h = this->fEndPoint.h + arrowPt1.h;
		segments[3].p.v = this->fEndPoint.v + arrowPt1.v;
		segments[3].in = segments[3].out = segments[3].p;
		segments[3].corner = true;
        
        // back to the point of the crescendo
		segments[4].p.h = this->fStartingPoint.h;
		segments[4].p.v = this->fStartingPoint.v;
		segments[4].in = segments[4].out = segments[4].p;
		segments[4].corner = true;
		
		// the other side of the opening of the crescendo
		segments[5].p.h = this->fEndPoint.h + arrowPt2.h;
		segments[5].p.v = this->fEndPoint.v + arrowPt2.v;
		segments[5].in = segments[5].out = segments[5].p;
		segments[5].corner = true;
        
        // the flared part of the crescendo on that side
		segments[6].p.h = this->fEndPoint.h + arrowPt4.h;
		segments[6].p.v = this->fEndPoint.v + arrowPt4.v;
		segments[6].in = segments[6].out = segments[6].p;
		segments[6].corner = true;
        
        // back to te opening of the crescendo on that side
        segments[7].p.h = this->fEndPoint.h + arrowPt2.h;
		segments[7].p.v = this->fEndPoint.v + arrowPt2.v;
		segments[7].in = segments[7].out = segments[7].p;
		segments[7].corner = true;
		
		// back to the point of the crescendo
		segments[8].p.h = this->fStartingPoint.h;
		segments[8].p.v = this->fStartingPoint.v;
		segments[8].in = segments[8].out = segments[8].p;
		segments[8].corner = true;
		
		error = sAIPath->SetPathSegments( path, 0, 9, segments );
		if ( error )
			goto error;
    }
    
	else if ( message->tool == this->fToolHandle[3] ) {
        
		//	FLARED DIMINUENDO
		error = sAIPath->SetPathSegmentCount( path, 9 );
        
		// the point of the diminuendo
		segments[0].p.h = this->fEndPoint.h;
		segments[0].p.v = this->fEndPoint.v;
		segments[0].in = segments[0].out = segments[0].p;
		segments[0].corner = true;
        
		// angles created by line segments
		pathAngle = sAIRealMath->AIRealPointAngle( &this->fEndPoint, &this->fStartingPoint );
		arrowAngle = sAIRealMath->DegreeToRadian( _ShortToAIReal(8) );
        arrowAngle2 = sAIRealMath->DegreeToRadian( _ShortToAIReal(30));
		sAIRealMath->AIRealPointLengthAngle( _ShortToAIReal(10), pathAngle + arrowAngle, &arrowPt1 );
        sAIRealMath->AIRealPointLengthAngle( _ShortToAIReal(9), pathAngle + arrowAngle2, &arrowPt3 );
		sAIRealMath->AIRealPointLengthAngle( _ShortToAIReal(10), pathAngle - arrowAngle, &arrowPt2 );
        sAIRealMath->AIRealPointLengthAngle( _ShortToAIReal(9), pathAngle - arrowAngle2, &arrowPt4 );
        
		// one side of the opening of the diminuendo
		segments[1].p.h = this->fStartingPoint.h - arrowPt1.h;
		segments[1].p.v = this->fStartingPoint.v - arrowPt1.v;
		segments[1].in = segments[1].out = segments[1].p;
		segments[1].corner = true;
        
        // the flared part of the diminuendo on that side
		segments[2].p.h = this->fStartingPoint.h - arrowPt3.h;
		segments[2].p.v = this->fStartingPoint.v - arrowPt3.v;
		segments[2].in = segments[2].out = segments[2].p;
		segments[2].corner = true;
        
        // back to the point of the opening
		segments[3].p.h = this->fStartingPoint.h - arrowPt1.h;
		segments[3].p.v = this->fStartingPoint.v - arrowPt1.v;
		segments[3].in = segments[3].out = segments[3].p;
		segments[3].corner = true;
        
        // back to the point of the diminuendo
		segments[4].p.h = this->fEndPoint.h;
		segments[4].p.v = this->fEndPoint.v;
		segments[4].in = segments[4].out = segments[4].p;
		segments[4].corner = true;
		
		// the other side of the opening of the diminuendo
		segments[5].p.h = this->fStartingPoint.h - arrowPt2.h;
		segments[5].p.v = this->fStartingPoint.v - arrowPt2.v;
		segments[5].in = segments[5].out = segments[5].p;
		segments[5].corner = true;
        
        // the flared part of the diminuendo on that side
		segments[6].p.h = this->fStartingPoint.h - arrowPt4.h;
		segments[6].p.v = this->fStartingPoint.v - arrowPt4.v;
		segments[6].in = segments[6].out = segments[6].p;
		segments[6].corner = true;
        
        // back to the point of the opening on this side
        segments[7].p.h = this->fStartingPoint.h - arrowPt2.h;
		segments[7].p.v = this->fStartingPoint.v - arrowPt2.v;
		segments[7].in = segments[7].out = segments[7].p;
		segments[7].corner = true;
		
		// back to the point of the diminuendo
		segments[8].p.h = this->fEndPoint.h;
		segments[8].p.v = this->fEndPoint.v;
		segments[8].in = segments[8].out = segments[8].p;
		segments[8].corner = true;
		
		error = sAIPath->SetPathSegments( path, 0, 9, segments );
		if ( error )
			goto error;

	}
    
	error = sAIPath->SetPathClosed( path, true );
	if ( error )
		goto error;
	
	pathStyle.strokePaint = true;
	pathStyle.stroke.color.kind = kGrayColor;
	pathStyle.stroke.color.c.g.gray = kAIRealOne;
	pathStyle.stroke.width = 0.498; // as are the same objects in the Lilypond font
	error = sAIPathStyle->SetPathStyle( path, &pathStyle );
    
error:
	return error;
}

/*
 */
ASErr MultiArrowToolPlugin::AddAnnotator(SPInterfaceMessage *message)
{
	ASErr result = kNoErr;
	try
	{
		result = sAIAnnotator->AddAnnotator(message->d.self, "MultiArrowTool Annotator", &fAnnotatorHandle);
		aisdk::check_ai_error(result);
        
		result = sAIAnnotator->SetAnnotatorActive(fAnnotatorHandle, false);
		aisdk::check_ai_error(result);
	}
	catch (ai::Error& ex)
	{
		result = ex;
	}
	catch(...)
	{
		result = kCantHappenErr;
	}
	return result;
}

/*
 */
ASErr MultiArrowToolPlugin::DrawAnnotator(AIAnnotatorMessage* message)
{
	ASErr result = kNoErr;
	try
	{
		// Get the string to display in annotator.
		ai::UnicodeString pointStr;
		result = this->GetPointString(fEndPoint, pointStr);
		aisdk::check_ai_error(result);
        
		AIPoint annotatorPoint;
		result = sAIDocumentView->ArtworkPointToViewPoint(NULL, &fEndPoint, &annotatorPoint);
        
		// Move 5 points right and 5 points up.
		annotatorPoint.h += 5;
		annotatorPoint.v -= 5;
        
		// Find cursor bound rect.
		AIRect annotatorRect;
		result = sAIAnnotatorDrawer->GetTextBounds(message->drawer, pointStr, &annotatorPoint,false, annotatorRect);
		aisdk::check_ai_error(result);
        
		// Draw a filled rectangle, the following R, G and B values combined makes light yellow.
		unsigned short red = 65000;
		unsigned short green = 65000;
		unsigned short blue = 40000;
		AIRGBColor yellowFill = {red, green, blue};
		sAIAnnotatorDrawer->SetColor(message->drawer, yellowFill);
		result = sAIAnnotatorDrawer->DrawRect(message->drawer, annotatorRect, true);
		aisdk::check_ai_error(result);
        
		// Draw black outline, 0 for R, G and B makes black.
		unsigned short black = 0;
		AIRGBColor blackFill = {black, black, black};
		sAIAnnotatorDrawer->SetColor(message->drawer, blackFill);
		sAIAnnotatorDrawer->SetLineWidth(message->drawer, 0.5);
		result = sAIAnnotatorDrawer->DrawRect(message->drawer, annotatorRect, false);
		aisdk::check_ai_error(result);
        
		// Draw cursor text.
		result = sAIAnnotatorDrawer->SetFontPreset(message->drawer, kAIAFSmall);
		aisdk::check_ai_error(result);
        
		result = sAIAnnotatorDrawer->DrawTextAligned(message->drawer, pointStr, kAICenter, kAIMiddle, annotatorRect);
		aisdk::check_ai_error(result);
        
		// Save old rect
		oldAnnotatorRect = annotatorRect;
	}
	catch (ai::Error& ex)
	{
		result = ex;
	}
	return result;
}

ASErr MultiArrowToolPlugin::InvalAnnotator(AIAnnotatorMessage *message)
{
	ASErr result = sAIAnnotator->InvalAnnotationRect(NULL, &oldAnnotatorRect);
    
	return result;
}

ASErr MultiArrowToolPlugin::InvalidateRect(const AIRect& invalRect)
{
	ASErr result = kNoErr;
	try {
		// Invalidate the rect bounds so it is redrawn.
		result = sAIAnnotator->InvalAnnotationRect(NULL, &invalRect);
		aisdk::check_ai_error(result);
	}
	catch (ai::Error& ex) {
		result = ex;
	}
	return result;
}

/*
 */
ASErr MultiArrowToolPlugin::InvalidateRect(const AIRealRect& invalRealRect)
{
	ASErr result = kNoErr;
	try {
		// invalRealRect is in artwork coordinates, convert to view
		// coordinates for AIAnnotatorSuite::InvalAnnotationRect.
		AIRect invalRect;
		result = this->ArtworkBoundsToViewBounds(invalRealRect, invalRect);
		aisdk::check_ai_error(result);
        
		// Invalidate the rect bounds so it is redrawn.
		result = sAIAnnotator->InvalAnnotationRect(NULL, &invalRect);
		aisdk::check_ai_error(result);
	}
	catch (ai::Error& ex) {
		result = ex;
	}
	return result;
}

/*
 */
ASErr MultiArrowToolPlugin::ArtworkBoundsToViewBounds(const AIRealRect& artworkBounds, AIRect& viewBounds)
{
	ASErr result = kNoErr;
	try {
		AIRealPoint tlArt, brArt;
		tlArt.h = artworkBounds.left;
		tlArt.v = artworkBounds.top;
		brArt.h = artworkBounds.right;
		brArt.v = artworkBounds.bottom;
        
		// Convert artwork coordinates to view coordinates.
		AIPoint tlView, brView;
		result = sAIDocumentView->ArtworkPointToViewPoint(NULL, &tlArt, &tlView);
		aisdk::check_ai_error(result);
		result = sAIDocumentView->ArtworkPointToViewPoint(NULL, &brArt, &brView);
		aisdk::check_ai_error(result);
        
		viewBounds.left = tlView.h;
		viewBounds.top = tlView.v;
		viewBounds.right = brView.h;
		viewBounds.bottom = brView.v;
	}
	catch (ai::Error& ex) {
		result = ex;
	}
	return result;
}

/*
 */
ASErr MultiArrowToolPlugin::GetPointString(const AIRealPoint& point, ai::UnicodeString& pointStr)
{
	ASErr result = kNoErr;
	try
	{	
		ASInt32 precision = 2;
		ai::UnicodeString horiz, vert;
		ai::NumberFormat numFormat;
        
		horiz = numFormat.toString((float) point.h, precision, horiz);
		vert = numFormat.toString((float) -point.v, precision, vert);
        
		pointStr.append(ai::UnicodeString("h: ")
                        .append(horiz)
                        .append(ai::UnicodeString(", v: ")
                                .append(vert)));
	}
	catch (ai::Error& ex)
	{
		result = ex;
	}
	return result;
}

ASErr MultiArrowToolPlugin::PostStartupPlugin()
{
    AIErr result = kNoErr;
    result = sAIUser->CreateCursorResourceMgr(fPluginRef,&fResourceManagerHandle);
    return result;
}

// End MultiArrowToolPlugin.cpp
