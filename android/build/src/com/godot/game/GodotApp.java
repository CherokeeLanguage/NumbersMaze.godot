/*************************************************************************/
/*  GodotApp.java                                                        */
/*************************************************************************/
/*                       This file is part of:                           */
/*                           GODOT ENGINE                                */
/*                      https://godotengine.org                          */
/*************************************************************************/
/* Copyright (c) 2007-2021 Juan Linietsky, Ariel Manzur.                 */
/* Copyright (c) 2014-2021 Godot Engine contributors (cf. AUTHORS.md).   */
/*                                                                       */
/* Permission is hereby granted, free of charge, to any person obtaining */
/* a copy of this software and associated documentation files (the       */
/* "Software"), to deal in the Software without restriction, including   */
/* without limitation the rights to use, copy, modify, merge, publish,   */
/* distribute, sublicense, and/or sell copies of the Software, and to    */
/* permit persons to whom the Software is furnished to do so, subject to */
/* the following conditions:                                             */
/*                                                                       */
/* The above copyright notice and this permission notice shall be        */
/* included in all copies or substantial portions of the Software.       */
/*                                                                       */
/* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,       */
/* EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF    */
/* MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.*/
/* IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY  */
/* CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,  */
/* TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE     */
/* SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.                */
/*************************************************************************/

package com.godot.game;

import android.app.UiModeManager;
import android.content.Context;
import android.content.res.Configuration;
import android.os.Bundle;
import android.util.Log;

import androidx.annotation.NonNull;

import com.cherokeelessons.maze.R;

import org.godotengine.godot.FullScreenGodotApp;
import org.godotengine.godot.Godot;

import java.util.Arrays;

/**
 * Template activity for Godot Android custom builds.
 * Feel free to extend and modify this class for your custom logic.
 */
public class GodotApp extends FullScreenGodotApp {

	protected static final String TAG = GodotApp.class.getSimpleName();

	@Override
	public void onCreate(Bundle savedInstanceState) {
		setTheme(R.style.GodotAppMainTheme);
		super.onCreate(savedInstanceState);
	}

	@NonNull
	@Override
	protected Godot initGodotInstance() {
		final Godot godot = new MyGodot();
		return godot;
	}

	public static class MyGodot extends Godot {
		@Override
		protected String[] getCommandLine() {
			String[] args = super.getCommandLine();
			args = Arrays.copyOf(args, args.length+1);
			args[args.length-1] = "--tv="+ isTv();
			return args;
		}

		protected boolean isTv() {
			if (uiMode() == Configuration.UI_MODE_TYPE_TELEVISION) {
				Log.i(TAG, "Running on a TV Device: true");
				return true;
			} else {
				Log.i(TAG, "Running on a TV Device: false");
				return false;
			}
		}

		protected int uiMode() {
			Context context = this.getContext();// getApplicationContext();
			UiModeManager uiModeManager = (UiModeManager) context.getSystemService(Context.UI_MODE_SERVICE);
			return uiModeManager.getCurrentModeType();
		}
	}
}
